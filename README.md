# URV SDG tracker
## About
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

## Methods
As a result, it becomes essential to develop a systematic method for evaluating the extent to which URV’s academic programs align with the SDGs, 
ensuring that educational offerings contribute effectively to the broader sustainability strategy.

With the aim of evaluating the presence of the SDGs in the courses at the Universitat Rovira i Virgili, the following methodology was employed: First, web scraping and text mining techniques were used to extract the contents of the course guides. These contents were then translated into English to be analyzed, and finally, a data analysis in R was performed to evaluate the terms related to the SDGs and define their presence in the URV's courses.

## Extracted Data

To obtain the content of the courses, it was necessary to extract data from the course guides of the corresponding subjects. This was achieved through multiple web scraping processes aimed at accessing the content of the guides. Initially, links to the subjects were extracted from the links to the faculties and schools of the URV. After accessing these links, detailed information about the courses (both undergraduate and master's) was extracted. For example, one of these links would be: https://guiadocent.urv.cat/guido/public/centres/503/ensenyaments/3475/detall, where "503" refers to the code of the faculty or school, in this case, the Faculty of Tourism and Geography, and "3475" to the course, Bachelor's Degree in Geography, Territorial Analysis, and Sustainability.

Once inside the framework with content and structure of the course, the following data was extracted from each course:

- degree_url: Link to the degree (e.g., https://guiadocent.urv.cat/guido/public/centres/503/ensenyaments/3475/detall)
- degree_name: Name of the degree (e.g., "Bachelor's Degree in Geography, Territorial Analysis, and Sustainability")
- degree_year: Academic year (e.g., "2018")
- faculty_school_url: Link to the faculty or school (e.g., https://guiadocent.urv.cat/guido/public/centres/503/ensenyaments/gestionar)
- faculty_school_name: Name of the faculty or school (e.g., "Faculty of Tourism and Geography")
- course_url: Link to the subject (e.g., https://guiadocent.urv.cat/guido/public/centres/503/ensenyaments/3475/assignatures/115109/guia_docent_docnet)
- course_code: Subject code (e.g., "115109")
- course_name: Name of the subject (e.g., "European Spaces")
- course_delivery_mode: Modality (e.g., "Face-to-face", "Semi-face-to-face", "Virtual")
- course_period: Period (e.g., "First semester", "Second semester", "Annual")
- course_type: Type of subject (e.g., "Basic F", "Optional", "Mandatory")
- credits: Credits (e.g., "4.5", "6")

## App Format

The information is extracted in two formats: Docnet (93% of the subjects) and Guido (the remaining 7%). Docnet is the older and temporary format, as there is currently a transition underway from this format to Guido. However, Docnet still exists in many course guides. Guido is the new format that should be incorporated into all course guides, although only new or recently revised courses currently use it.

To access the Docnet format guides, it was necessary to retrieve the link to the iframe containing them. An example of this link would be: Docnet Link.

In the Guido format, similar data is extracted, with the difference that competencies are integrated with learning outcomes, and visual access to the data requires going through each section. Using the following example link: Guido Link.

In both formats, coordinators, professors, descriptions, contents, learning outcomes, competencies, and references were extracted (noting that in the Guido format, competencies are integrated into learning outcomes). Subsequently, the extracted information was organized into a dataframe that integrates the details of the course guide, course, and complementary information, as well as the corresponding faculty or school.


## Identification of SDGs

The methodological analysis used to identify and quantify the Sustainable Development Goals (SDGs) in the content of the course guides of the university programs was based on the detection of keywords related to the SDGs.

To achieve this objective, various sources were identified that provided sets of keywords associated with the SDGs. Since all the content was originally in Catalan, it was first automatically translated into English using LibreTranslate (executed in a Docker container via Docker Compose) and complementarily Apertium, although the translations from the former were chosen.

- Sustainable Development Goals (SDGs) Keywords (2022) from the University of Toronto: This source provides a detailed list of 388 keywords in English related to the SDGs.
- Institut Teknologi Sepuluh Nopember: This institute classifies hundreds of terms in English related to the SDGs. 
- University of Auckland: Provides a map of keywords for the 17 SDGs, allowing download in English. 
- Joint Research Centre of the EU and its tool SDG Mapper: This tool allows mapping SDGs in texts. 
- text2SDG: An open-source analysis tool in R developed by Meier, Mata, and Wulff (2022), which allows identifying and quantifying SDGs in texts.
Among these sources, text2SDG, an open-source analysis package in the R programming language, was ultimately used to identify the SDGs and related words in the contents of the courses at the URV. This tool allowed the identification of SDGs in texts through scientific query systems. Although all identified sources provided an extensive set of words classified according to the 17 SDGs, text2SDG was considered particularly advantageous for its utility and efficiency in the automatic identification of SDGs in large volumes of text.

## Final Structure

Finally, the SDGs were identified, and the information was synthesized along with the detailed data of the subjects. This synthesis was organized into a JSON format structured by faculties, courses, subjects, the SDGs associated with their content, and the terms related to the SDGs. This format allows for quick and iterative consultation of the results, facilitating the identification of the faculties or schools, courses, and subjects most aligned with the SDGs.

## Project Limitations

The project faced several limitations that affected the handling of data and the analysis process to identify SDGs in the courses:

Junk Content: The presence of incomplete or poorly formatted data required extensive manual review, affecting the efficiency of the process. This data could include empty cells, strange characters, or poorly spaced references, which had to be corrected to ensure the quality of the analysis. Such cases were particularly common in bibliographic references or competencies and learning outcomes.
Incorrect Content Location: The presence of content in incorrect locations or cells in the course guide where it does not belong. This means that the detection of SDGs in certain courses may not be entirely consistent with reality.
Format Differences: The variability between the Docnet and Guido formats complicated the uniform extraction of data, especially in the web scraping phase. This difference required adjustments in the automated data retrieval code to ensure that data was extracted correctly in each format. The main differences were in the framework encompassing the contents; specifically, the Docnet format displays the contents in an iframe, which required an additional step in the extraction process to access the complete contents of the course guide.
Reliability of Translations: Ensuring the reliability of translations is crucial for obtaining the correct identification of terms related to the SDGs. Although multiple translation tools, LibreTranslate and Apertium, were used, the precision in translating technical and specific terms presented difficulties in some cases. In the case of the Apertium package, the translation of compound words, anglicisms, or technical terms was not entirely reliable, while LibreTranslate provided better translations. However, format changes were made to the content (incorporating line breaks in bibliographic references or context in the names of the subjects) to enable a more comprehensive translation.

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


