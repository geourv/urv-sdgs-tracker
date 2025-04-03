# URV SDG tracker
## About
This project analyzes the alignment of URV academic programs with the Sustainable Development Goals (ODS). 
Using web scraping and text mining, we extract program descriptions, 
translate them, and then perform data analysis in R to evaluate ODS-related terms. 
The results are published as a website in the `docs` folder and hosted via GitHub Pages. 

The initial approach of this study has been informed by the following two references: 
**[Informe sobre la docència i la recerca en sostenibilitat i medi ambient a 
la Universitat Rovira i Virgili](https://llibres.urv.cat/index.php/purv/catalog/view/103/89/214)**
Informe sobre la docència i la recerca en sostenibilitat i medi ambient a la Universitat Rovira i Virgili 
(Alberich González et al., 2012), which provides an in-depth analysis of sustainability and environmental 
education at URV, and the study **[La sostenibilidad en los grados universitarios: presencia y coherencia]
(https://revistas.usal.es/tres/index.php/1130-3743/article/view/teoredu291161187/17347)** 
by Bautista-Cerro Ruiz and Díaz González (2017), which examines the presence of 
sustainability within university degree programs.

These works provide an initial perspective on how to analyze the integration of sustainability
into higher education curricula and serve as a basis for developing our methodological framework.

Furthermore, future legal obligations in Spain, as mandated by European Union legislation, 
establish the need for uiversities, as outlined in the **[Resolution of April 26, 2023]
(https://www.boe.es/diario_boe/txt.php?id=BOE-A-2023-10858)**,
to actively contribute to the achievement of the Sustainable Development Goals (SDGs) 
in alignment with the 2030 Agenda.

This resolution, a collaboration between the Secretaría de Estado para la Agenda 2030 
and the Conferencia de Rectores de las Universidades Españolas, 
underscores the importance of monitoring and ensuring compliance 
with sustainability objectives.

## Methods
As a result, it becomes essential to develop a systematic method for evaluating 
the extent to which URV’s academic programs align with the SDGs, 
ensuring that educational offerings contribute effectively 
to the broader sustainability strategy.

With the aim of evaluating the presence of the SDGs in the courses at the 
Universitat Rovira i Virgili, the following methodology was employed: First, 
web scraping and text mining techniques were used to extract the contents of the course guides. 
These contents were then translated into English to be analyzed, and finally, 
a data analysis in R was performed to evaluate the terms related to the SDGs 
and define their presence in the URV's courses.

## Extracted Data

To obtain the content of the study programs, it is necessary to extract data 
from the course guides of the corresponding subjects.
This has been achieved through multiple web scraping processes—using 
the **Firefox WebScraper Plugin**—aimed at accessing the content of the guides.

Initially, the links to the courses were extracted from the faculty and school links of URV.
After accessing these links, detailed information about the study programs 
(both undergraduate and master's) was extracted.

For example, one of these links would be: 
https://guiadocent.urv.cat/guido/public/centres/503/ensenyaments/3475/detall, 
where "503" refers to the code of the faculty or school, in this case, 
the Faculty of Tourism and Geography, and "3475" to the course, 
Bachelor's Degree in Geography, Territorial Analysis, and Sustainability.

Once inside the framework with content and structure of the course, 
the following data was extracted from each course:

- **degree_url**: Link to the degree (e.g., 
https://guiadocent.urv.cat/guido/public/centres/503/ensenyaments/3475/detall)

- **degree_name**: Name of the degree (e.g., 
"Bachelor's Degree in Geography, Territorial Analysis, and Sustainability")

- **degree_year**: Academic year (e.g., 
"2018")

- **faculty_school_url**: Link to the faculty or school (e.g., 
https://guiadocent.urv.cat/guido/public/centres/503/ensenyaments/gestionar)

- **faculty_school_name**: Name of the faculty or school (e.g., 
"Faculty of Tourism and Geography")

- **course_url**: Link to the subject (e.g., 
https://guiadocent.urv.cat/guido/public/centres/503/ensenyaments/3475/assignatures/115109/guia_docent_docnet)

- **course_code**: Subject code (e.g., 
"115109")

- **course_name**: Name of the subject (e.g., 
"European Spaces")

- **course_delivery_mode**: Modality (e.g., 
"Face-to-face", "Semi-face-to-face", "Virtual")

- **course_period**: Period (e.g., 
"First semester", "Second semester", "Annual")

- **course_type**: Type of subject (e.g., 
"Basic F", "Optional", "Mandatory")

- **credits**: Credits (e.g., 
"4.5", "6")

## Course guide management
The information is extracted in two standards: **DOCnet** (93% of the courses) and **GUIDO** (the remaining 7%). 
DOCnet is a web application designed to help faculty plan their courses 
according to the parameters defined by the Bologna Process and create the 
course guides. DOCnet is the previous and temporary standard, 
as a transition is currently underway from DOCnet to the new application called GUIDO.

Nevertheless, DOCnet is still the current standard for many course guides. 
GUIDO is the new standard that will soon be incorporated into all course guides, 
although it is currently only available for new or recently updated programs.

To access the DOCnet format guides, it was necessary to retrieve the link 
to the iframe link containing them. An example of this link would be: [DOCnet Link]
(https://guiadocent.urv.cat/docnet/guia_docent/assignatures/print/?centre=21&ensenyament=2123&assignatura=21234217&any_academic=2024_25&idioma=cat&modalitat=p).

In the GUIDO format, similar data is extracted, with the difference 
that competencies are integrated with learning outcomes, 
and visual access to the data requires going through each section. 
Using the following example link: [GUIDO Link]
(https://guiadocent.urv.cat/guido/public/centres/498/ensenyaments/3545/assignatures/116896/guia_docent).

In both formats, coordinators, professors, descriptions, contents, 
learning outcomes, competencies, and references were extracted 
(noting that in the GUIDO format, competencies are integrated into learning outcomes). 
Subsequently, the extracted information was organized into a dataframe that 
integrates the details of the course guide, course, and complementary information, 
as well as the corresponding faculty or school.

***Limitations:*** *The presence of incomplete or poorly formatted data has required manual review, affecting the efficiency of the process. This data may include empty fields, unusual characters, or improperly spaced references, which ***should be reviewed course by course to ensure the quality of the analysis***. Such cases have been particularly common in the contents of bibliographic references, competencies, and learning outcomes.*

*Incorrect placement of content in sections or fields of the course guide where they do not belong has also been detected. This issue means that in certain programs, the detection of SDGs (Sustainable Development Goals) is not entirely accurate.*

*The variability between the DOCnet and GUIDO standards has complicated the uniform extraction of data, especially during the data mining or web mining phase. This difference has required the creation of two separate models for automated data extraction to ensure the correct retrieval of data for each standard. The main differences lie in the framework that structures the content: specifically, the DOCnet standard displays content within an iframe, whose link had to be extracted through an additional step in the extraction process, whereas the GUIDO standard allows direct access to the information.*


## Identification of SDGs

The methodological analysis used to identify and quantify the 
Sustainable Development Goals (SDGs) in the content of the course guides 
of the university programs was based on the detection of keywords related to the SDGs.

To achieve this objective, various sources were identified that provided sets 
of keywords associated with the SDGs. Since all the content was originally in Catalan, 
it was first automatically translated into English using LibreTranslate 
(executed in a Docker container via Docker Compose) and complementarily Apertium, 
although the translations from the former were chosen.

- **Sustainable Development Goals (SDGs) Keywords** (2022) from the University of Toronto: 
This source provides a detailed list of 388 keywords in English related to the SDGs.
[More information](https://sustainability.utoronto.ca/inventories/sustainable-development-goals-sdgs-keywords/)

- **Institut Teknologi Sepuluh Nopember**: This institute classifies hundreds of terms in English related to the SDGs. 
[More information](https://www.its.ac.id/drpm/wp-content/uploads/sites/71/2021/04/Daftar-keywords-Sustainable-Development-Goals.pdf)

- **University of Auckland**: Provides a map of keywords for the 17 SDGs, allowing download in English. 
[More information](https://www.its.ac.id/drpm/wp-content/uploads/sites/71/2021/04/Daftar-keywords-Sustainable-Development-Goals.pdf)

- **Joint Research Centre of the EU** and its tool **SDG Mapper**: This tool allows mapping SDGs in texts. 
[More information](https://knowsdgs.jrc.ec.europa.eu/sdgmapper)

- **text2SDG**: An open-source analysis tool in R developed by Meier, Mata, and Wulff (2022), 
which allows identifying and quantifying SDGs in texts. [More information](https://www.text2sdg.io/reference/text2sdg.html)

Among these sources, **text2SDG**, an open-source analysis package in the R programming language, 
was ultimately used to identify the SDGs and related words in the contents of the courses at the URV. 
This tool allowed the identification of SDGs in texts through scientific query systems. 
Although all identified sources provided an extensive set of words classified according to the 17 SDGs, 
text2SDG was considered particularly advantageous for its utility and 
efficiency in the automatic identification of SDGs in large volumes of text.

***Limitations:*** *Ensuring reliability in translations is crucial, as it is an essential step for accurately identifying terms related to the SDGs. Although various translation tools have been used, including LibreTranslate and Apertium, translating technical and specific terms has sometimes posed challenges. In the case of the Apertium package, the translation of compound words, anglicisms, or technical terms has not been entirely reliable, whereas LibreTranslate has provided more accurate translations. However, formatting adjustments have been made to the content (such as adding line breaks in bibliographic references or context to course names) to enable a more comprehensive translation. ***It would be necessary to review the content before translation by incorporating contextual texts or characters that allow the translation tool to interpret the text more accurately.***

## Final Structure

Finally, the SDGs were identified, and the information was synthesized 
along with the detailed data of the subjects. This synthesis was organized into a 
JSON format structured by faculties, courses, subjects, the SDGs associated with their content, 
and the terms related to the SDGs. This format allows for quick and iterative consultation of the results, 
facilitating the identification of the faculties or schools, courses, 
and subjects most aligned with the SDGs.

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


