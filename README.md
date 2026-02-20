Projet Moteur : Alpharisus

Alpharisus est un moteur de jeu dont la genèse s'étendra sur les années à venir. Actuellement en phase de planification et de sélection des dépendances, il se dessine comme une structure où l'ambition technique côtoie une efficacité sans concession.
I. Les Piliers Techniques (Dépendances)

Plutôt que de perdre mon temps à réinventer la roue, j'ai choisi de m'appuyer sur des fondations éprouvées pour les aspects les plus fastidieux du développement :

    Physique : La gestion des collisions et de la dynamique sera confiée à PhysX. Si l'envie me prend de plonger dans les arcanes de la physique plus tard, je le ferai, mais pour l'heure, laissons cela à ceux qui l'ont déjà      perfectionné.

    Audio : Par pure "flemme" — ou plutôt par une saine économie d'énergie — je refuse de manipuler manuellement les formats de données sonores. Le choix se portera sur OpenAL ou FMOD selon les besoins futurs.

    Journalisation (Logging) : Un système de logs robuste est indispensable pour observer le chaos. Ce rôle sera dévolu à spdlog.

    Interface utilisateur : L’interface de débogage et de contrôle sera propulsée par ImGui, l’outil de prédilection pour ceux qui préfèrent l’efficacité à l’esthétique de surface.

    Réseau : J’envisage l’intégration de SpaceTimeDB pour explorer les frontières du multijoueur synchrone, une fois les bases du moteur solidifiées.

II. Architecture du Système

Le moteur sera structuré autour d'une séparation stricte entre le noyau et l'application, utilisant une approche ECS (Entity Component System) pour une performance optimale.

    Cœur du Moteur (Engine) : * Gestionnaire de rendu (initialement OpenGL, avec une transition prévue vers l'austère mais puissante API Vulkan).

        Systèmes de base : Son, Physique, Logging.

    Application (App) : * La couche supérieure où s'articulera la logique spécifique au projet.

III. Vision Graphique et Recherches

Mon regard se porte vers des techniques de rendu non conventionnelles, privilégiant la précision mathématique et l'efficacité géométrique :

    SDF (Signed Distance Fields) & Ray Marching : Inspiration puisée chez Inigo Quilez et Sebastian Lague pour des rendus organiques et procéduraux.

    Optimisation de Terrain : Utilisation de concepts comme les GeomClipmaps et les techniques de magnification de textures alpha-testées pour garantir une fluidité sans faille.

ressource:
 https://www.youtube.com/watch?v=Cp5WWtMoeKg

https://www.shadertoy.com/view/lslXD8

https://steamcdn-a.akamaihd.net/apps/valve/2007/SIGGRAPH2007_AlphaTestedMagnification.pdf

https://jcgt.org/published/0011/03/06/paper-lowres.pdf

https://hhoppe.com/geomclipmap.pdf

https://iquilezles.org/articles/

* 

esquice de structure:
<img width="2095" height="1226" alt="GlobalEngineArchitectureDiagram drawio" src="https://github.com/user-attachments/assets/c0513b16-29fc-469e-8a51-da04461baaf2" />

ce procject je personnel va probablement longtmep des anné pour comprendre enfin totalement tout les concept que j'ai envie d'explorer  dns ce project ke pense me concentrer le rendu et les  syteme principale comme ecs, le syteme de loggin, 