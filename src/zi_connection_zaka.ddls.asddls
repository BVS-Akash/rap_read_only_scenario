@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for connection'
@Metadata.ignorePropagatedAnnotations: true

@UI.headerInfo : {
                   typeName : 'Connection',
                   typeNamePlural : 'Connections',
                      title: {
      value: 'ConnectionId' }
}

@Search.searchable: true

define view entity zi_connection_zaka 
as select from /dmo/connection as Connection
association [1..*] to zi_flight_zaka as _Flight
on $projection.CarrierId = _Flight.CarrierId
and $projection.ConnectionId =  _Flight.ConnectionId

association [1] to zi_carrier_zaka as _Airline
on $projection.CarrierId = _Airline.CarrierId
{

@UI.facet: [{
    id: 'ConnectionDetails',
    type: #IDENTIFICATION_REFERENCE,
    position: 10,
    label: 'Connection Details'
},
    {
    id : 'FlightDetails',
    type : #LINEITEM_REFERENCE,
    position : 20,
    label : 'Flights',
    targetElement: '_Flight'
}
]
    @UI.lineItem: [{ position : 10 , label : 'Airline' }]
    @UI.identification: [{ position : 10 }]
    @ObjectModel.text.association : '_Airline'
    @Search.defaultSearchElement: true
    key carrier_id as CarrierId,
    @UI.lineItem: [{ position : 20 }]
    @UI.identification: [{ position : 20 }]
    @Search.defaultSearchElement: true
    key connection_id as ConnectionId,
    @UI.lineItem: [{ position : 30 }]
    @UI.selectionField: [{ position : 10 }]
    @UI.identification: [{ position : 30 }]
    @Search.defaultSearchElement: true
    @Consumption.valueHelpDefinition: [{ entity : {
                                                     name : 'zi_airport_vh_zaka',
                                                     element :  'AirportId'
    } }]
    airport_from_id as AirportFromId,
    @UI.lineItem: [{ position : 40 }]
    @UI.selectionField: [{ position : 20 }]
    @UI.identification: [{ position : 40 }]
    @Search.defaultSearchElement: true
    @Consumption.valueHelpDefinition: [{ entity : {
                                                     name : 'zi_airport_vh_zaka',
                                                     element :  'AirportId'
    } }]
    airport_to_id as AirportToId,
    @UI.lineItem: [{ position : 50 , label : 'Departure Time' }]
    @UI.identification: [{ position : 50 }]
    departure_time as DepartureTime,
    @UI.lineItem: [{ position : 60 , label : 'Arrival Time'}]
    @UI.identification: [{ position : 60 }]
    arrival_time as ArrivalTime,
    @Semantics.quantity.unitOfMeasure: 'DistanceUnit'
    @UI.identification: [{ position : 70 , label : 'Distance'}]
    cast( distance as abap.quan(15,2) ) as Distance,
    distance_unit as DistanceUnit,
    
// -> Associations
    @Search.defaultSearchElement: true
    _Flight,
    @Search.defaultSearchElement: true
    _Airline
}
