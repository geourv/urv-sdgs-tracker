# URV SDG tracker

This project analyzes the alignment of URV academic programs with the Sustainable Development Goals (ODS). 
Using web scraping and text mining, we extract program descriptions, translate them, and then perform data analysis in R to evaluate ODS-related terms. 
The results are published as a website in the `docs` folder and hosted via GitHub Pages. 

The initial approach of this study has been informed by the following two references: 
Informe sobre la docència i la recerca en sostenibilitat i medi ambient a la Universitat Rovira i Virgili (Alberich González et al., 2012), which provides an in-depth analysis of sustainability and environmental education at URV, and the study La sostenibilidad en los grados universitarios: presencia y coherencia by Bautista-Cerro Ruiz and Díaz González (2017), which examines the presence of sustainability within university degree programs.

These works provide an initial perspective on how to analyze the integration of sustainability
into higher education curricula and serve as a basis for developing our methodological framework.

Furthermore, future legal obligations in Spain, as mandated by European Union legislation, 
establish the need for uiversities, as outlined in the Resolution of April 26, 2023,
to actively contribute to the achievement of the Sustainable Development Goals (SDGs) in alignment with the 2030 Agenda. 
This resolution, a collaboration between the Secretaría de Estado para la Agenda 2030 and the Conferencia de Rectores de las Universidades Españolas, 
underscores the importance of monitoring and ensuring compliance with sustainability objectives.

As a result, it becomes essential to develop a systematic method for evaluating the extent to which URV’s academic programs align with the SDGs, 
ensuring that educational offerings contribute effectively to the broader sustainability strategy.

To gather the course content, it was necessary to extract the data from the corresponding course guides. 
This was achieved through multiple web scraping processes aimed at accessing these guides. 
Initially, links to the courses were extracted based on the faculties and schools of URV. 
After accessing these links, detailed information about the courses (both undergraduate and master’s) was retrieved. 
For instance, one such link would be: https://guiadocent.urv.cat/guido/public/centres/495/ensenyaments/3467/detall, 
where "495" refers to the faculty and "3467" to the specific course.

Once inside the course details, data such as the course name and academic year were extracted. 
Subsequently, key information regarding the courses was scraped, including the following details:

-degree_url (e.g., https://guiadocent.urv.cat/guido/public/centres/498/ensenyaments/3545)
-degree_name (e.g., "Bachelor in Computer Science")
-degree_year (e.g., "2023")
-faculty_school_url</strong>: Enllaç a la facultat/escola
-faculty_school_name</strong>: Nom de la facultat/escola
-course_url (e.g., https://guiadocent.urv.cat/guido/public/centres/498/ensenyaments/3545/assignatures/116896/guia_docent)
-course_code (e.g., "116896")
-course_name (e.g., "Introduction to Programming")
-course_delivery_mode (e.g., "Presencial", "Semipresencial", "Virtual")
-course_period (e.g., "Primer quadrimestre", "Segon quadrimestre", "Anual")
-course_type (e.g., "F Bàsica", "Optativa", "Obligatòria")
-credits (e.g., 4.5, 6)
-year (e.g., "Primer curs", "Segon curs", "Tercer curs", "Quart curs")

It’s worth mentioning that two approaches were required to collect the data from the course guides, as there are two formats: 
Docnet and Guido. Docnet, the original format, includes 4,290 subjects, accounting for 93% of the total subjects, 
while Guido is a newer version to which some courses have already transitioned, containing 339 subjects. 

To access the Docnet guides, it was necessary to retrieve the link to the iframe containing these guides, 
one such link would be for example: 
https://guiadocent.urv.cat/docnet/guia_docent/assignatures/print/?centre=21&ensenyament=2123&assignatura=21234217&any_academic=2024_25&idioma=cat&modalitat=p. 

From the Docnet format, detailed information was extracted for each subject, including the course coordinators, professors, description, content, competences, learning results, and references. 
Using the following example link: https://guiadocent.urv.cat/guido/public/centres/498/ensenyaments/3545/assignatures/116896/guia_docent.

In the Guido format, similar data was extracted—coordinators, professors, descriptions, content, learning results, and
references—although competences are integrated into the learning outcomes and are not listed separately.

Ultimately, all extracted information was organized into a dataframe, consolidating the details from the course guides, 
the subjects, the degree programs, and the corresponding faculties.

The methodological analysis used to identify and quantify the Sustainable Development Goals (SDGs) in the content of course guides for university programs (undergraduate and master's) 
was based on the detection of keywords related to the SDGs. 

To achieve this objective, various sources providing sets of SDG-related keywords were identified. 
Since all the content was originally in Catalan, it was first automatically translated into English using LibreTranslate 
(running in a Docker container via Docker Compose). Among these sources, the document Sustainable Development Goals (SDGs) Keywords (2022), 
developed by the Committee on the Environment, Climate Change, and Sustainability (CECCS) at the University of Toronto, stands out. 

It organizes 388 English-language keywords, each associated with different SDGs.

The Institut Teknologi Sepuluh Nopember classifies hundreds of words related to the SDGs. Also available in English, this source is of particular interest.

The University of Auckland offers a keyword map linked to the 17 SDGs, with the possibility of downloading them in English.

The Joint Research Centre of the European Union has developed the SDG Mapper tool, which detects the presence of SDGs in texts through an interactive platform.

Finally, text2SDG, an open-source analysis package in the R programming language, has been identified. 
This tool allows for the identification of SDGs in texts using scientific query systems. The model was developed by Meier, Mata, and Wulff (2022).

Although all the identified sources provide an extensive set of words categorized according to the 17 SDGs, 
the open-source text2SDG tool has been considered particularly advantageous due to its usefulness and efficiency in automatically identifying SDGs in large volumes of text.

Finally, the SDGs were identified and the information was synthesized along with the detailed data of the subjects. 
This synthesis was organized in a JSON format, which is structured starting with the faculty, followed by the courses, subjects, and, ultimately, the SDGs associated with the respective content.

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


