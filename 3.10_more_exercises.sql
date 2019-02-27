-- World Database
-- Use the world database for the questions below.

USE world;
SHOW TABLES;

-- What Languages are spoken in Santa Monica?
SELECT *
FROM country;
-- field needed to join country to countrylanguage: 'code' on "USA" value

SELECT *
FROM countrylanguage;
-- field neede to join countrylanguage to country: 'CountryCode' on "USA" value

SELECT *
FROM city;
-- field needed to join city to countrylanguage: 'CountryCode' on "USA" value
-- also return 'Name' field

++++++++
SELECT Language
	Percentage
    Name
FROM countrylanguage A
	LEFT OUTER JOIN country B ON A.code = B.CountryCode
    LEFT OUTER JOIN city C ON A.code = C.CountryCode
WHERE CountryCode = 'USA'
   -- LEFT OUTER JOIN city C ON CountryCode = code
-- WHERE CountryCode = 'USA'
;
++++++++



SELECT A.Language
	A.Percentage
FROM countrylanguage A
	LEFT OUTER JOIN city B ON CountryCode = CountryCode
WHERE CountryCode = 'USA'
;



SELECT A.Language
	,A.CountryCode
    ,B.Name
    ,B.
FROM countrylanguage A
	LEFT OUTER JOIN city B ON A. = B.Name

 city
WHERE Name = 'Santa Monica'
;

FROM CAMP_ANALYST_DEV.DBO.t_C0110_CAPER_1MRS_FY15 A WITH (NOLOCK)
	LEFT OUTER JOIN CAMP_ANALYST.REF.DMIS_ID B ON A.treatment_dmis_id = B.dmis_id
	LEFT OUTER JOIN CAMP_ANALYST.REF.MSDRG C ON (A.mdc = C.mdc
		AND A.fy = C.fy)
	LEFT OUTER JOIN CAMP_ANALYST.REF.HIPAA_TAXONOMY D ON A.appt_provider_specialty_hipaa = D.hipaa_taxonomy
	LEFT OUTER JOIN CAMP_ANALYST.REF.CHCS_PROVIDER_SPECIALTY E ON A.appt_provider_spec = E.specialty_code
WHERE B.facility_service_code IN ('F','G','3')
	AND A.meprs_1 IN ('A','B')


