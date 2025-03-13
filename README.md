# URV SDG tracker

This project analyzes the alignment of URV academic programs with the Sustainable Development Goals (ODS). Using web scraping and text mining, we extract program descriptions, translate them, and then perform data analysis in R to evaluate ODS-related terms. The results are published as a website in the `docs` folder and hosted via GitHub Pages. 

See the results at: [URL]

## Dependencies
- **Docker** and **Docker Compose** (for managing the translation service)
- **Firefox WebScraper Plugin** (for data collection)
- All required R packages are listed in the `requirements.R` file in the repository. Run:
```r
source("requirements.R")
```
to install all necessary dependencies.

## How It Works
1. **Data Collection:**
   - Web scraping is performed using the **Firefox WebScraper Plugin** to extract program descriptions.
   - Extracted data is structured and cleaned in **R**.

2. **Translation:**
   - Program descriptions are translated into English using **LibreTranslate** (running in a **Docker container** via Docker Compose).

3. **Data Processing & Analysis:**
   - Translated text is processed and analyzed using **dplyr, tidyr, stringr**, and other R packages.
   - The **[sdg package](https://cran.r-project.org/web/packages/sdg/index.html)** is used for evaluating ODS-related terms.
   - The results are compiled into a website stored in the `docs` folder for publication via GitHub Pages.

## TODO / Roadmap
- Allow users to select between **LibreTranslate** and **Apertium** for translations.
- Convert the `translate_column` function into a standalone, parameterized script so it can be used outside of RStudio.
- Improve visualizations for clearer representation of ODS term occurrences.
- Expand dataset coverage to include more university programs.
- Enhance scraping efficiency and implement better error handling.
- Improve modularity of R scripts for better integration with Docker workflows.
- Finalize the website in the `docs` folder and configure GitHub Pages for automatic updates.


