/*
 * Library: IMMZ.IND.55
 * Immunization coverage for non-birth doses of oral polio containing vaccine (Estimated Denominator) 
 * Compares the administered doses of oral polio containing vaccines (OPV) which are non-birth doses (dose sequence > 0) with the estimated number of surviving infants expressed as a percentage.
 * 
 * Numerator: Number of administrations of vaccinations using an oral polio vaccine (OPV) where the dose sequnece > 0, during the reporting period. 
 * Numerator Computation: COUNT immunization events WHERE administered product is a polio vaccine (IMMZ.A1.DE26) and dose sequence > 0 during reporting period
 * Denominator: Number of registered surviving infants
 * Denominator Computation: COUNT Patient WHERE age at reporting period < 12 months AND deceasedDate is not populated.
 * 
 * Disaggregation:
 *   - Dose sequence (1, 2, 3)
 *   - Age Group (< 1 year or > 1 year)
 *   - Geographic Region
 *   - Administrative Gender (or Biological Sex)
 * 
 * References: WHO Immunization Facility Analysis Guide (1), WHO / UNICEF Joint Reporting Form (3 - elements 4130 - 4160)
 */

library IMMZIND55

// Start Skeleton CQL
using FHIR version '4.0.1'
include FHIRHelpers version '4.0.1'
include IMMZCommon called IMMZCom
include IMMZConcepts called IMMZc
include IMMZConfig called IMMZCon
include IMMZIndicatorCommon called IMMZIndCom
include IMMZVaccineLibrary called IMMZvl
include FHIRCommon called FC
// End Skeleton CQL
parameter "Measurement Period" Interval<Date>

context Patient

/*
 * Numerator: Number of administrations of vaccinations using an oral polio vaccine (OPV) where the dose sequnece > 0, during the reporting period.
 * Numerator Computation: COUNT immunization events WHERE administered product is a polio vaccine (IMMZ.A1.DE26) and dose sequence > 0 during reporting period
 */
define "numerator":
	exists(IMMZIndCom."bOPV Non-Birth Doses Administered to Patient During Measurement Period")


/*
 * Denominator: Number of registered surviving infants
 * Denominator Computation: COUNT Patient WHERE age at reporting period < 12 months AND deceasedDate is not populated.
 */
define "denominator":
	IMMZIndCom."Patient Under 12 Months Old During Measurement Period"
	and not (IMMZIndCom."Patient Deceased During Measurement Period")

/*
 * Disaggregator: Dose sequence (1, 2, 3)
 */
define "Dose sequence Stratifier":
	IMMZIndCom."bOPV Non-Birth Doses Administered to Patient During Measurement Period" I
	return (singleton from I.protocolApplied).doseNumber

/*
 * Disaggregator: Age Group (< 1 year or > 1 year)
 */
define "Age Group Stratifier":
	IMMZIndCom."Infant By Age Stratifier" 

/*
 * Disaggregator: Geographic Region
 */
define "Geographic Region Stratifier":
	IMMZIndCom."By Geographic Region Stratifier" 

/*
 * Disaggregator: Administrative Gender (or Biological Sex)
 */
define "Administrative Gender Stratifier":
	IMMZIndCom."By Administrative Gender Stratifier" 

/* End of IMMZ.IND.55 */
