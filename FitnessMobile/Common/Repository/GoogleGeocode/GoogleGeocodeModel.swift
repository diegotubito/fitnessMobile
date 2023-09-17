//
//  GeocodingModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 14/09/2023.
//

import Foundation

struct GoogleGeocodeModel: Codable {
    let status: String
    let results: [Result]
    
    
    struct Result: Codable, Identifiable, Hashable {
        var id: UUID? = UUID()
        let addressComponents: [AddressComponent]
        let formattedAddress: String
        let geometry: Geometry
        let placeID: String
        let plusCode: PlusCode?
        let types: [String]
        
        enum CodingKeys: String, CodingKey {
            case addressComponents = "address_components"
            case formattedAddress = "formatted_address"
            case geometry
            case placeID = "place_id"
            case plusCode = "plus_code"
            case types
        }
    }

    struct AddressComponent: Codable, Identifiable, Hashable {
        var id: UUID? = UUID()
        let longName: String
        let shortName: String
        let types: [String]
        
        enum CodingKeys: String, CodingKey {
            case longName = "long_name"
            case shortName = "short_name"
            case types
        }
    }

    struct Geometry: Codable, Identifiable, Hashable {
        var id: UUID? = UUID()
        let location: Location
        let locationType: String
        
        enum CodingKeys: String, CodingKey {
            case location
            case locationType = "location_type"
        }
    }

    struct Location: Codable, Identifiable, Hashable {
        var id: UUID? = UUID()
        let lat: Double
        let lng: Double
    }

    struct PlusCode: Codable, Identifiable, Hashable {
        var id: UUID? = UUID()
        let compoundCode: String
        let globalCode: String
        
        enum CodingKeys: String, CodingKey {
            case compoundCode = "compound_code"
            case globalCode = "global_code"
        }
    }
    
    enum AddressComponentNameType {
        case short
        case long
    }

    enum AddressComponentType: String {
        case route = "route"
        case streetNumber = "street_number"
        case postalCode = "postal_code"
        case postalCodeSuffix = "postal_code_suffix"
        case streetAddress = "street_address"
        case country
        case locality = "locality"
        case sublocality = "sublocality"
        case sublocalityLevel1 = "sublocality_level_1"
        case sublocalityLevel2 = "sublocality_level_2"
        case administrativeAreaLevel1 = "administrative_area_level_1"
        case administrativeAreaLevel2 = "administrative_area_level_2"
    }
}


