@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value help for airport'
@Metadata.ignorePropagatedAnnotations: true

@Search.searchable: true

define view entity zi_airport_vh_zaka as select from /dmo/airport
{
    key airport_id as AirportId,
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.8
    name as Name,
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.8
    city as City,
    @Search.defaultSearchElement: true
    country as Country
}
