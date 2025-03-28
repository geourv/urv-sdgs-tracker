# Estructura del projecte i manteniment del lloc web

Aquest repositori conté una pàgina web estàtica allotjada a **GitHub Pages** dins la carpeta `docs/`. La web es construeix amb **HTML, CSS i JavaScript** sense d'un servidor.

## Estructura de carpetes

```
urv-sdgs-tracker/
│── docs/                           # Carpeta principal per a GitHub Pages
│   ├── index.html                  # Pàgina principal
│   ├── README.md                   # Explicació del projecte
│   ├── CNAME                       # Opcional: domini personalitzat
│   ├── 404.html                    # Pàgina d'error personalitzada
│   ├── pages/                      # Pàgines addicionals
│   │   ├── index.html              # Inici
│   │   ├── faculty.html            # Visualització resultats per facultats i escoles
│   │   ├── degree.html             # Visualització resultats per ensenyaments
│   │   ├── course.html             # Visualització resultats per assignatures
│   │   ├── methods.html            # Metodologia
│   │   ├── about.html              # Sobre el projecte
│   │   ├── contact.html            # Contacte
│   │   ├── iframes/                # Gràfiques i resultats
│   │   │   ├── [x].html            # Gràfica [x]
│   │   │   ├── ...
│   ├── data/                       # Dades JSON. Tants fitxers com sigui necessari per fer més ràpida o fàcil de mantindre la web.
│   │   ├── urv-sdg.json            # Dades de facultats i escoles, ensenyaments i assignatures
│   │   ├── faculties_sdg_data.json # Estadístiques de facultats
│   │   ├── ...
│   ├── downloads/                  # Fitxers descarregables (PDFs, ZIPs)
│   ├── assets/                     # Recursos compartits (CSS, JS, imatges)
│   │   ├── css/                    # Fulls d'estil
│   │   │   ├── styles.css          # Estils generals
│   │   ├── js/                     # JavaScript
│   │   │   ├── script.js           # Codi JS principal
│   │   ├── ...
│   │   ├── images/                 # Imatges i icones de la estructura e la web o dels continguts.
│   │   ├── logos/                  # Els logos d'ODS en format vectorial i multilingüe.
│   │   ├── fonts/                  # Opcional: Tipografies personalitzades. De moment millor com a recursos.
│   ├── sitemap.xml                 # Opcional: mapa del lloc per SEO
│   ├── robots.txt                  # Opcional: Control d'indexació per cercadors
```

## Com utilitzar

### 1. Activar GitHub Pages
1. Ves a **Settings** → **Pages**.
2. A "Branch", selecciona **main** i la carpeta `docs/`.
3. Guarda els canvis i accedeix a la web des de `https://nom-usuari.github.io/nom-repositori/`.

### 2. Editar el contingut
- **Treballar en local i no fer commits si la web no funciona**.
- **Modificar pàgines** → Edita `index.html` o afegeix fitxers a `pages/`.
- **Afegir estils personalitzats** → Modifica `assets/css/styles.css`.
- **Carregar dades dinàmiques** → Utilitza JSON des de `data/` i carrega'l amb `fetch()` a `assets/js/script.js`.


## 🛠️ Millores possibles
- [ ] Crear dades en format adequat per a l'anàlsis visual.
- [ ] Fer demos amb les llibreries de JS més habituals.
- [ ] Afegir una navegació dinàmica.
- [ ] Implementar un disseny responsiu.
- [ ] Millorar el SEO amb `sitemap.xml` i `robots.txt`.

📌 **Fet amb ❤️ per geourv**


