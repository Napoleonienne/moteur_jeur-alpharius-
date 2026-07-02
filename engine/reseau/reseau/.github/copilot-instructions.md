# SpacetimeDB Core Concepts

SpacetimeDB is a relational database that is also a server. It lets you upload application logic directly into the database via WebAssembly modules, eliminating the traditional web/game server layer entirely.

---

## Critical Rules

1. **Reducers are transactional.** They do not return data to callers. Use subscriptions to read data.
2. **Reducers must be deterministic.** No filesystem, network, timers, or random. All state must come from tables.
3. **Read data via tables/subscriptions**, not reducer return values. Clients get data through subscribed queries.
4. **Auto-increment IDs are not sequential.** Gaps are normal, do not use for ordering. Use timestamps or explicit sequence columns.
5. **`ctx.sender` is the authenticated principal.** Never trust identity passed as arguments.

---

## Feature Implementation Checklist

1. **Backend:** Define table(s) to store the data
2. **Backend:** Define reducer(s) to mutate the data
3. **Client:** Subscribe to the table(s)
4. **Client:** Call the reducer(s) from UI
5. **Client:** Render the data from the table(s)

---

## Debugging Checklist

1. Is SpacetimeDB server running? (`spacetime start`)
2. Is the module published? (`spacetime publish`)
3. Are client bindings generated? (`spacetime generate`)
4. Check server logs for errors (`spacetime logs <db-name>`)
5. Is the reducer actually being called from the client?

---

## Tables

- **Private tables** (default): Only accessible by reducers and the database owner.
- **Public tables**: Exposed for client read access through subscriptions. Writes still require reducers.

Organize data by access pattern, not by entity:

```
Player          PlayerState         PlayerStats
id         <--  player_id           player_id
name            position_x          total_kills
                position_y          total_deaths
                velocity_x          play_time
```

## Reducers

Reducers are transactional functions that modify database state. They run atomically, cannot interact with the outside world, and do not return data to callers. See the language-specific server skills for syntax.

## Event Tables

Event tables broadcast reducer-specific data to clients. Rows are never stored in the client cache (`count()` returns 0, `iter()` yields nothing); only `onInsert` callbacks fire.

## Subscriptions

Subscriptions replicate database rows to clients in real-time.

1. **Subscribe**: Register SQL queries describing needed data
2. **Receive initial data**: All matching rows are sent immediately
3. **Receive updates**: Real-time updates when subscribed rows change
4. **React to changes**: Use callbacks (`onInsert`, `onDelete`, `onUpdate`)

Best practices:
- Group subscriptions by lifetime
- Subscribe before unsubscribing when updating subscriptions
- Avoid overlapping queries
- Use indexes for efficient queries

## Modules

Modules are WebAssembly bundles containing application logic that runs inside the database.

- **Tables**: Define the data schema
- **Reducers**: Define callable functions that modify state
- **Event Tables**: Broadcast reducer-specific data to clients
- **Views**: Read-only functions that expose computed subsets of data to clients
- **Procedures**: (Unstable) Functions that can have side effects (HTTP requests, `ctx.withTx`)

Server-side modules can be written in: Rust, C#, TypeScript, C++

Lifecycle: Write → Compile → Publish (`spacetime publish`) → Hot-swap (republish without disconnecting clients)

## Identity

- **Identity**: A long-lived, globally unique identifier for a user.
- **ConnectionId**: Identifies a specific client connection.
- Always use `ctx.sender` / `ctx.Sender` / `ctx.sender()` for authorization.

SpacetimeDB works with many OIDC providers, including SpacetimeAuth (built-in), Auth0, Clerk, Keycloak, Google, and GitHub.


# SpacetimeDB CLI

Use this skill when the user needs help with the `spacetime` CLI tool - initializing projects, building modules, publishing databases, querying data, managing servers, or troubleshooting CLI issues.

## Quick Reference

### Project Initialization & Development

```bash
# Initialize new project
spacetime init my-project --lang rust|csharp|typescript|cpp
spacetime init my-project --template <template-id>

# Build module
spacetime build                    # release build
spacetime build --debug            # faster iteration, slower runtime

# Dev mode (auto-rebuild, auto-publish, generates bindings)
spacetime dev
spacetime dev --client-lang typescript --module-bindings-path ./client/src/module_bindings

# Generate client bindings
spacetime generate --lang typescript|csharp|rust|unrealcpp --out-dir ./bindings --module-path ./server
```

### Publishing & Deployment

```bash
# Publish to Maincloud (default)
spacetime publish my-database --yes

# Publish to local server
spacetime publish my-database --server local --yes

# Clear database and republish
spacetime publish my-database --delete-data always --yes
```

### Database Interaction

```bash
# SQL queries
spacetime sql my-database "SELECT * FROM users"
spacetime sql my-database --interactive   # REPL mode

# Call reducers (each argument is a separate positional arg)
spacetime call my-database my_reducer '"value"' '123'

# Subscribe to changes
spacetime subscribe my-database "SELECT * FROM users" --num-updates 10

# View logs
spacetime logs my-database -f              # follow logs
spacetime logs my-database -n 100          # up to 100 log lines

# Describe schema
spacetime describe my-database --json
spacetime describe my-database table users --json
spacetime describe my-database reducer my_reducer --json
```

### Database Management

```bash
# List databases
spacetime list

# Delete database
spacetime delete my-database

# Rename database
spacetime rename <database-identity> --to new-name
```

### Server Management

```bash
# List configured servers
spacetime server list

# Add server
spacetime server add local --url http://localhost:3000 --default
spacetime server add myserver --url https://my-spacetime.example.com

# Set default server
spacetime server set-default local

# Test connectivity
spacetime server ping local

# Start local instance
spacetime start

# Clear local data
spacetime server clear
```

### Authentication

```bash
# Login (opens browser)
spacetime login

# Login with token
spacetime login --token <token>

# Show login status
spacetime login show

# Logout
spacetime logout
```

## Default Servers

| Name | URL | Description |
|------|-----|-------------|
| `maincloud` | `https://maincloud.spacetimedb.com` | Production cloud (default) |
| `local` | `http://127.0.0.1:3000` | Local development server |

## Common Flags

| Flag | Short | Description |
|------|-------|-------------|
| `--server` | `-s` | Target server (nickname, hostname, or URL) |
| `--yes` | `-y` | Non-interactive mode (skip confirmations) |
| `--anonymous` | | Use anonymous identity |
| `--module-path` | `-p` | Path to module project |

## Troubleshooting

### "Not logged in"
```bash
spacetime login
# Or use --anonymous for public operations
```

### "Server not responding"
```bash
spacetime server ping <server>
# For local: ensure spacetime start is running
```

### "Schema conflict"
```bash
# Clear data and republish
spacetime publish my-db --delete-data always --yes
```

### "Build failed"
```bash
# Check Rust/C# toolchain
rustup show
# For Rust modules, ensure wasm32-unknown-unknown target
rustup target add wasm32-unknown-unknown
```

## Module Languages

**Server-side (modules):** Rust, C#, TypeScript, C++
**Client SDKs:** TypeScript, C#, Rust, Unreal Engine
**CLI `generate` targets:** TypeScript, C#, Rust, Unreal C++



# SpacetimeDB C++ SDK Reference

## Imports

```cpp
#include <spacetimedb.h>
using namespace SpacetimeDB;
```

## Tables

Register structs with macros, then declare as tables:

```cpp
struct Entity {
    uint64_t id;
    Identity owner;
    std::string name;
    bool active;
};
SPACETIMEDB_STRUCT(Entity, id, owner, name, active)
SPACETIMEDB_TABLE(Entity, entity, Public)
FIELD_PrimaryKeyAutoInc(entity, id)
FIELD_Index(entity, name)
```

Options:
- `SPACETIMEDB_TABLE(Type, accessor, Public|Private)`: regular table
- `SPACETIMEDB_TABLE(Type, accessor, Public|Private, true)`: event table

Field constraints:
- `FIELD_PrimaryKey(accessor, field)`: primary key
- `FIELD_PrimaryKeyAutoInc(accessor, field)`: primary key with auto-increment (use 0 on insert)
- `FIELD_Unique(accessor, field)`: unique constraint
- `FIELD_Index(accessor, field)`: btree index (enables `.filter()`)

## Column Types

| C++ type | Notes |
|----------|-------|
| `uint8_t` / `uint16_t` / `uint32_t` / `uint64_t` | unsigned integers |
| `SpacetimeDB::u128` / `SpacetimeDB::u256` | large unsigned integers |
| `int8_t` / `int16_t` / `int32_t` / `int64_t` | signed integers |
| `SpacetimeDB::i128` / `SpacetimeDB::i256` | large signed integers |
| `float` / `double` | floats |
| `bool` | boolean |
| `std::string` | text |
| `std::vector<T>` | list/array |
| `std::optional<T>` | nullable column |
| `Identity` | user identity |
| `ConnectionId` | connection handle |
| `Timestamp` | server timestamp (microseconds since epoch) |
| `TimeDuration` | duration in microseconds |
| `ScheduleAt` | for scheduled tables |

## Indexes

```cpp
// Single-column:
FIELD_Index(entity, name)
// Access: ctx.db[entity_name].filter("Alice")

// Multi-column:
FIELD_NamedMultiColumnIndex(score, by_player_and_level, player_id, level)
```

Range queries (requires `#include <spacetimedb/range_queries.h>`):
```cpp
ctx.db[user_age].filter(range_inclusive(uint8_t(18), uint8_t(65)));
ctx.db[user_age].filter(range_from(uint8_t(18)));
```

## Reducers

All reducers return `ReducerResult`. Use `Ok()` or `Err(message)`:

```cpp
SPACETIMEDB_REDUCER(create_entity, ReducerContext ctx, std::string name) {
    if (name.empty()) {
        return Err("Name cannot be empty");
    }
    ctx.db[entity].insert(Entity{0, ctx.sender(), name, true});
    return Ok();
}
```

## DB Operations

```cpp
ctx.db[entity].insert(Entity{0, owner, "Sample", true});     // Insert (0 for autoInc)
ctx.db[entity_id].find(entityId);                             // Find by PK → std::optional
ctx.db[entity_identity].find(ctx.sender());                   // Find by unique column
ctx.db[entity_name].filter("Alice");                          // Filter by index → iterable
ctx.db[entity];                                               // All rows → iterable (range-for)
ctx.db[entity].count();                                       // Count rows

// Update: find, mutate, update
if (auto e = ctx.db[entity_id].find(entityId)) {
    e->name = "New Name";
    ctx.db[entity_id].update(*e);
}

// Delete by primary key
ctx.db[entity_id].delete_by_key(entityId);
```

Note: Bracket notation `ctx.db[accessor]` is used for all table access. The accessor name comes from `SPACETIMEDB_TABLE` and `FIELD_*` macros.

## Lifecycle Hooks

```cpp
SPACETIMEDB_INIT(init, ReducerContext ctx) {
    LOG_INFO("Database initializing...");
    return Ok();
}

SPACETIMEDB_CLIENT_CONNECTED(on_connect, ReducerContext ctx) {
    LOG_INFO("Connected: " + ctx.sender().to_string());
    return Ok();
}

SPACETIMEDB_CLIENT_DISCONNECTED(on_disconnect, ReducerContext ctx) {
    LOG_INFO("Disconnected: " + ctx.sender().to_string());
    return Ok();
}
```

## Authentication & Timestamps

```cpp
// Auth: ctx.sender() is the caller's Identity
if (row.owner != ctx.sender()) {
    return Err("unauthorized");
}

// Server timestamps
ctx.db[item].insert(Item{0, ctx.sender(), ctx.timestamp});

// Timestamp arithmetic
Timestamp later = ctx.timestamp + TimeDuration::from_seconds(10);
```

## Reducer Context

`ReducerContext` is the single source of sender identity, deterministic time, and deterministic randomness inside a reducer. Always go through `ctx` for these. Standard library clocks and random sources are not available in modules.

```cpp
ctx.db[table]          // Table access (bracket notation)
ctx.sender()           // Caller's Identity
ctx.timestamp          // Invocation timestamp
ctx.connection_id      // std::optional<ConnectionId>
ctx.identity()         // Module's own identity
ctx.rng()              // Deterministic RNG
ctx.sender_auth()      // AuthCtx with JWT claims
```

## Scheduled Tables

```cpp
struct Reminder {
    uint64_t scheduled_id;
    ScheduleAt scheduled_at;
    std::string message;
};
SPACETIMEDB_STRUCT(Reminder, scheduled_id, scheduled_at, message)
SPACETIMEDB_TABLE(Reminder, reminder, Public)
FIELD_PrimaryKeyAutoInc(reminder, scheduled_id)
SPACETIMEDB_SCHEDULE(reminder, 1, send_reminder)  // 1 = scheduled_at field index (0-based)

SPACETIMEDB_REDUCER(send_reminder, ReducerContext ctx, Reminder arg) {
    LOG_INFO("Reminder: " + arg.message);
    return Ok();
}

// One-time: fires at a specific time
ctx.db[reminder].insert(Reminder{0, ScheduleAt::time(ctx.timestamp + TimeDuration::from_seconds(10)), "msg"});
// Repeating: fires on an interval
ctx.db[reminder].insert(Reminder{0, ScheduleAt::interval(TimeDuration::from_seconds(5)), "msg"});
```

## Custom Types

```cpp
// Struct (product type):
struct Point { float x; float y; };
SPACETIMEDB_STRUCT(Point, x, y)

// Enum (sum type):
SPACETIMEDB_UNIT_TYPE(Active)
SPACETIMEDB_UNIT_TYPE(Inactive)
SPACETIMEDB_ENUM(PlayerStatus,
    (Active, Active),
    (Inactive, Inactive),
    (Suspended, std::string)
)
```

## Logging

```cpp
LOG_INFO("Message: " + msg);
LOG_WARN("Warning: " + msg);
LOG_ERROR("Error: " + msg);
LOG_DEBUG("Debug: " + msg);
LOG_PANIC("Fatal: " + msg);   // terminates reducer
```

## Complete Example

```cpp
#include <spacetimedb.h>
using namespace SpacetimeDB;

struct Entity {
    Identity identity;
    std::string name;
    bool active;
};
SPACETIMEDB_STRUCT(Entity, identity, name, active)
SPACETIMEDB_TABLE(Entity, entity, Public)
FIELD_PrimaryKey(entity, identity)

struct Record {
    uint64_t id;
    Identity owner;
    uint32_t value;
    Timestamp created_at;
};
SPACETIMEDB_STRUCT(Record, id, owner, value, created_at)
SPACETIMEDB_TABLE(Record, record, Public)
FIELD_PrimaryKeyAutoInc(record, id)

SPACETIMEDB_CLIENT_CONNECTED(on_connect, ReducerContext ctx) {
    if (auto existing = ctx.db[entity_identity].find(ctx.sender())) {
        existing->active = true;
        ctx.db[entity_identity].update(*existing);
    }
    return Ok();
}

SPACETIMEDB_CLIENT_DISCONNECTED(on_disconnect, ReducerContext ctx) {
    if (auto existing = ctx.db[entity_identity].find(ctx.sender())) {
        existing->active = false;
        ctx.db[entity_identity].update(*existing);
    }
    return Ok();
}

SPACETIMEDB_REDUCER(create_entity, ReducerContext ctx, std::string name) {
    if (ctx.db[entity_identity].find(ctx.sender())) {
        return Err("already exists");
    }
    ctx.db[entity].insert(Entity{ctx.sender(), name, true});
    return Ok();
}

SPACETIMEDB_REDUCER(add_record, ReducerContext ctx, uint32_t value) {
    if (!ctx.db[entity_identity].find(ctx.sender())) {
        return Err("not found");
    }
    ctx.db[record].insert(Record{0, ctx.sender(), value, ctx.timestamp});
    return Ok();
}
```


# SpacetimeDB Unreal Engine Integration

This skill covers Unreal Engine-specific patterns for connecting to SpacetimeDB. For server-side module development, see the `rust-server` or `csharp-server` skills.

---

## Installation

Add the SpacetimeDB Unreal SDK as a plugin:

1. Create a `Plugins` folder in your Unreal project root if it does not exist.
2. Copy the `SpacetimeDbSdk` folder into `Plugins/`.
3. Right-click your `.uproject` file and select **Generate Visual Studio project files**.
4. Add `"SpacetimeDbSdk"` to your module's `Build.cs`:

```csharp
PublicDependencyModuleNames.AddRange(new string[] { "SpacetimeDbSdk" });
```

---

## Generate Module Bindings

```bash
spacetime generate --lang unrealcpp \
  --uproject-dir <path_to_uproject_directory> \
  --module-path <path_to_spacetimedb_module> \
  --unreal-module-name <your_unreal_module_name>
```

This generates C++ bindings in `ModuleBindings/` inside your project. Include the generated header:

```cpp
#include "ModuleBindings/SpacetimeDBClient.g.h"
```

Regenerate whenever you change module tables, reducers, or types.

---

## GameManager Actor Pattern

The recommended pattern is a singleton Actor that owns the connection. Enable ticking so `FrameTick` is called every frame.

### Header (GameManager.h)

```cpp
#pragma once
#include "CoreMinimal.h"
#include "GameFramework/Actor.h"
#include "ModuleBindings/SpacetimeDBClient.g.h"
#include "GameManager.generated.h"

class UDbConnection;

UCLASS()
class AGameManager : public AActor
{
    GENERATED_BODY()
public:
    AGameManager();
    static AGameManager* Instance;

    UPROPERTY(EditAnywhere, Category="SpacetimeDB")
    FString ServerUri = TEXT("127.0.0.1:3000");

    UPROPERTY(EditAnywhere, Category="SpacetimeDB")
    FString DatabaseName = TEXT("my-module");

    UPROPERTY(BlueprintReadOnly, Category="SpacetimeDB")
    UDbConnection* Conn = nullptr;

    UPROPERTY(BlueprintReadOnly, Category="SpacetimeDB")
    FSpacetimeDBIdentity LocalIdentity;

protected:
    virtual void BeginPlay() override;
    virtual void EndPlay(const EEndPlayReason::Type EndPlayReason) override;
public:
    virtual void Tick(float DeltaTime) override;

private:
    UFUNCTION() void HandleConnect(UDbConnection* InConn, FSpacetimeDBIdentity Identity, const FString& Token);
    UFUNCTION() void HandleConnectError(const FString& Error);
    UFUNCTION() void HandleDisconnect(UDbConnection* InConn, const FString& Error);
    UFUNCTION() void HandleSubscriptionApplied(FSubscriptionEventContext& Context);
};
```

### Source (GameManager.cpp)

```cpp
#include "GameManager.h"
#include "Connection/Credentials.h"

AGameManager* AGameManager::Instance = nullptr;

AGameManager::AGameManager()
{
    PrimaryActorTick.bCanEverTick = true;
    PrimaryActorTick.bStartWithTickEnabled = true;
}

void AGameManager::BeginPlay()
{
    Super::BeginPlay();
    Instance = this;

    FOnConnectDelegate ConnectDelegate;
    BIND_DELEGATE_SAFE(ConnectDelegate, this, AGameManager, HandleConnect);
    FOnDisconnectDelegate DisconnectDelegate;
    BIND_DELEGATE_SAFE(DisconnectDelegate, this, AGameManager, HandleDisconnect);
    FOnConnectErrorDelegate ConnectErrorDelegate;
    BIND_DELEGATE_SAFE(ConnectErrorDelegate, this, AGameManager, HandleConnectError);

    UCredentials::Init(TEXT(".spacetime_token"));
    FString Token = UCredentials::LoadToken();

    UDbConnectionBuilder* Builder = UDbConnection::Builder()
        ->WithUri(ServerUri)
        ->WithDatabaseName(DatabaseName)
        ->OnConnect(ConnectDelegate)
        ->OnDisconnect(DisconnectDelegate)
        ->OnConnectError(ConnectErrorDelegate);

    if (!Token.IsEmpty())
    {
        Builder->WithToken(Token);
    }

    Conn = Builder->Build();
}

void AGameManager::EndPlay(const EEndPlayReason::Type EndPlayReason)
{
    if (Conn) { Conn->Disconnect(); Conn = nullptr; }
    if (Instance == this) { Instance = nullptr; }
    Super::EndPlay(EndPlayReason);
}

void AGameManager::Tick(float DeltaTime)
{
    if (Conn && Conn->IsActive())
    {
        Conn->FrameTick();
    }
}

void AGameManager::HandleConnect(UDbConnection* InConn, FSpacetimeDBIdentity Identity, const FString& Token)
{
    LocalIdentity = Identity;
    UCredentials::SaveToken(Token);

    FOnSubscriptionApplied AppliedDelegate;
    BIND_DELEGATE_SAFE(AppliedDelegate, this, AGameManager, HandleSubscriptionApplied);
    Conn->SubscriptionBuilder()
        ->OnApplied(AppliedDelegate)
        ->SubscribeToAllTables();
}

void AGameManager::HandleConnectError(const FString& Error)
{
    UE_LOG(LogTemp, Error, TEXT("Connection error: %s"), *Error);
}

void AGameManager::HandleDisconnect(UDbConnection* InConn, const FString& Error)
{
    UE_LOG(LogTemp, Warning, TEXT("Disconnected: %s"), *Error);
}

void AGameManager::HandleSubscriptionApplied(FSubscriptionEventContext& Context)
{
    UE_LOG(LogTemp, Log, TEXT("Subscription applied - game state loaded"));
}
```

---

## FrameTick -- Critical

**You must either call `Conn->FrameTick()` every frame in your Actor's `Tick()`, or call `Conn->SetAutoTicking(true)` once at startup.** The SDK queues all network messages and only processes them on tick. Without one of these, no callbacks fire and the client appears frozen.

---

## Connection Builder

Build a connection with the builder pattern. All builder methods return pointers for chaining with `->`.

```cpp
UDbConnection* Conn = UDbConnection::Builder()
    ->WithUri(TEXT("127.0.0.1:3000"))
    ->WithDatabaseName(TEXT("my-module"))
    ->WithToken(SavedToken)                              // optional
    ->WithCompression(ESpacetimeDBCompression::Gzip)     // optional
    ->OnConnect(ConnectDelegate)
    ->OnConnectError(ErrorDelegate)
    ->OnDisconnect(DisconnectDelegate)
    ->Build();
```

### OnConnect callback signature

```cpp
UFUNCTION()
void OnConnected(UDbConnection* Connection, FSpacetimeDBIdentity Identity, const FString& Token);
```

Save the `Token` for future reconnection. The `Identity` is the user's persistent identifier.

---

## Subscribing to Tables

After connecting, subscribe to receive table data:

```cpp
// Subscribe to all public tables
Conn->SubscriptionBuilder()
    ->OnApplied(AppliedDelegate)
    ->SubscribeToAllTables();

// Subscribe to specific queries
TArray<FString> Queries = { TEXT("SELECT * FROM player"), TEXT("SELECT * FROM entity") };
Conn->SubscriptionBuilder()
    ->OnApplied(AppliedDelegate)
    ->OnError(ErrorDelegate)
    ->Subscribe(Queries);
```

### Subscription Handle

`Subscribe` and `SubscribeToAllTables` return a `USubscriptionHandle*`:

```cpp
USubscriptionHandle* Handle = Conn->SubscriptionBuilder()->...->Subscribe(Queries);
Handle->IsActive();      // true while subscription is live
Handle->Unsubscribe();   // cancel the subscription
Handle->UnsubscribeThen(OnEndDelegate); // cancel with callback
Handle->GetQuerySqls();  // get the SQL queries
```

---

## Reading the Client Cache

Access tables through `Conn->Db`:

```cpp
// Find by unique/primary key (returns by value; default-constructed if not found)
FUserType User = Conn->Db->User->Identity->Find(SomeIdentity);

// Filter by BTree index
TArray<FPlayerType> LevelFive = Conn->Db->Player->Level->Filter(5);

// Iterate all rows
TArray<FEntityType> AllEntities = Conn->Db->Entity->Iter();

// Count
int32 Total = Conn->Db->Player->Count();
```

---

## Row Callbacks

Register callbacks on table objects. Callbacks use Unreal dynamic multicast delegates.

```cpp
// OnInsert
Conn->Db->User->OnInsert.AddDynamic(this, &AMyActor::OnUserInsert);

// OnDelete
Conn->Db->User->OnDelete.AddDynamic(this, &AMyActor::OnUserDelete);

// OnUpdate (only fires for rows with a primary key)
Conn->Db->User->OnUpdate.AddDynamic(this, &AMyActor::OnUserUpdate);
```

### Callback signatures (must be UFUNCTION)

```cpp
UFUNCTION()
void OnUserInsert(const FEventContext& Context, const FUserType& NewRow);

UFUNCTION()
void OnUserDelete(const FEventContext& Context, const FUserType& DeletedRow);

UFUNCTION()
void OnUserUpdate(const FEventContext& Context, const FUserType& OldRow, const FUserType& NewRow);
```

Register callbacks before connecting or in `HandleSubscriptionApplied`.

---

## Calling Reducers

Invoke reducers through `Conn->Reducers`:

```cpp
Conn->Reducers->SendMessage(TEXT("Hello!"));
Conn->Reducers->SetName(TEXT("Alice"));
Conn->Reducers->MovePlayer(1.0f, 0.0f);
```

### Reducer Result Callbacks

Observe when a reducer you called completes:

```cpp
Conn->Reducers->OnSendMessage.AddDynamic(this, &AMyActor::OnSendMessageResult);
```

```cpp
UFUNCTION()
void OnSendMessageResult(const FReducerEventContext& Context, const FString& Text)
{
    UE_LOG(LogTemp, Log, TEXT("SendMessage result for: %s"), *Text);
}
```

These delegates fire only for reducer calls made by this connection, not for other clients' calls.

---

## Delegate Binding with BIND_DELEGATE_SAFE

Use the `BIND_DELEGATE_SAFE` macro to safely bind delegates to member functions:

```cpp
FOnConnectDelegate ConnectDelegate;
BIND_DELEGATE_SAFE(ConnectDelegate, this, AMyActor, HandleConnect);
```

This is the recommended pattern for all SpacetimeDB delegate bindings in C++.

---

## Identity and ConnectionId

```cpp
// FSpacetimeDBIdentity -- 256-bit unique user identifier, persists across connections
FSpacetimeDBIdentity Identity;
Identity.ToHex();

// FSpacetimeDBConnectionId -- 128-bit per-session connection identifier
FSpacetimeDBConnectionId ConnId = Conn->GetConnectionId();

// From any context
FSpacetimeDBIdentity Id;
bool Found = Context.TryGetIdentity(Id);
FSpacetimeDBConnectionId CId = Context.GetConnectionId();
```

---

## Token Persistence

Use the built-in `UCredentials` helper to save and load tokens:

```cpp
UCredentials::Init(TEXT(".spacetime_token"));
FString Token = UCredentials::LoadToken();
// ... after connect:
UCredentials::SaveToken(Token);
```

---

## Context Types

All callbacks receive a context struct that provides access to `Db` and `Reducers`:

| Type | Used In |
|------|---------|
| `FEventContext` | Table row callbacks (OnInsert, OnDelete, OnUpdate) |
| `FReducerEventContext` | Reducer result callbacks |
| `FSubscriptionEventContext` | Subscription lifecycle callbacks (OnApplied, OnError) |
| `FErrorContext` | Error callbacks |

All inherit from `FContextBase` which provides:

```cpp
Context.Db          // URemoteTables* -- client cache
Context.Reducers    // URemoteReducers* -- invoke reducers
Context.SubscriptionBuilder()  // start a new subscription
```

---

## Blueprint Integration

All core classes are Blueprint-accessible via `UFUNCTION(BlueprintCallable)` and `UPROPERTY(BlueprintReadOnly/BlueprintAssignable)`:

- `UDbConnection::Builder()` and all builder methods are `BlueprintCallable`.
- Table callbacks (`OnInsert`, `OnDelete`, `OnUpdate`) are `BlueprintAssignable` delegates.
- Reducer invoke methods and result delegates are Blueprint-accessible.
- `Conn->Db` and `Conn->Reducers` are `BlueprintReadOnly` properties.
- Generated row types are `BlueprintType` USTRUCTs with `BlueprintReadWrite` properties.

This means you can build the entire connection and callback flow in Blueprints without writing C++.

---

## Unreal-Specific Considerations

### Auto Ticking Alternative

`UDbConnection` inherits from `FTickableGameObject`, but auto ticking is **off by default**. You have two options:

```cpp
// Option 1: Call FrameTick() manually in your Actor's Tick() (shown in GameManager above)
void Tick(float DeltaTime) { Conn->FrameTick(); }

// Option 2: Enable auto ticking. The SDK then processes messages every frame automatically
Conn->SetAutoTicking(true);
```

Pick one. Without either, no callbacks fire.

### Compression

```cpp
Builder->WithCompression(ESpacetimeDBCompression::Gzip);  // default
Builder->WithCompression(ESpacetimeDBCompression::None);   // no compression
```

### Generated Types

Codegen produces USTRUCTs prefixed with `F` (e.g., `FUserType`, `FEntityType`) and table classes prefixed with `U` (e.g., `UUserTable`). Row types use `GENERATED_BODY()` and `UPROPERTY()` for full reflection support.
