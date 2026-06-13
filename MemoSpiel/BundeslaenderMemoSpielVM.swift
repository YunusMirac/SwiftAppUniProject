//
//  BundeslaenderMemoSpielVM.swift
//  MemoSpiel
//
//  Created by Yunus Mirac Comart on 07.06.26.
//

import Foundation
import SwiftUI
import Combine
import MapKit

/// Ermöglicht Paarvergleiche im Model, obwohl SwiftUI-Images kein Equatable sind.
extension Image: @retroactive Equatable {
    public static func == (lhs: Image, rhs: Image) -> Bool {
        String(describing: lhs) == String(describing: rhs)
    }
}

/// ViewModel für das Bundesländer-Memospiel; bereitet Spiel- und Kartendaten für die View auf.
class BundeslaenderMemoSpielVM: ObservableObject {
    /// Koordinaten und Namen der Bundesländer; Schlüssel entspricht dem paarIndex der Karten.
    private static let bundeslaender: [String: (CLLocationCoordinate2D, String)] = [
        "0": (CLLocationCoordinate2D(latitude: 48.137154, longitude: 11.576124), "Bayern"),
        "1": (CLLocationCoordinate2D(latitude: 48.53778, longitude: 9.04111), "Baden-Wuerttemberg"),
        "2": (CLLocationCoordinate2D(latitude: 52.520008, longitude: 13.404954), "Berlin"),
        "3": (CLLocationCoordinate2D(latitude: 50.083, longitude: 11.917), "Franken"),
        "4": (CLLocationCoordinate2D(latitude: 52.017, longitude: 10.783), "Hessen"),
        "5": (CLLocationCoordinate2D(latitude: 52.427547, longitude: 10.780420), "Niedersachsen"),
        "6": (CLLocationCoordinate2D(latitude: 51.233334, longitude: 6.783333), "NRW"),
        "7": (CLLocationCoordinate2D(latitude: 49.28999000, longitude: 10.65971000), "Sachsen")
    ]
    
    /// Feste Kartenregion mit Fokus auf das Territorium der BRD.
    static let deutschlandRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.1657, longitude: 10.4515),
        span: MKCoordinateSpan(latitudeDelta: 10.0, longitudeDelta: 10.0)
    )
    
    /// Spielzustand aus dem Model; nur über Intents veränderbar.
    @Published private var memoSpielModel: MemoSpielModel<Image>
    /// ID der zuletzt angetippten Karte; Basis für Marker und Bundesland-Text.
    @Published private(set) var zuletztGewaehlteKartenId: String?
    
    /// Startet ein neues 4x4-Spiel mit allen acht Bundesland-Paaren.
    init() {
        memoSpielModel = Self.erzeugeMemoSpiel()
    }
    
    /// Alle Karten des aktuellen Spiels; read-only aus dem Model.
    var karten: Array<MemoSpielModel<Image>.Karte> {
        memoSpielModel.karten
    }
    
    /// Name des Bundeslandes der zuletzt relevanten Karte für die Anzeige unter der Karte.
    var bundeslandName: String {
        guard let paarIndex = paarIndexDerZuletztGewaehltenKarte,
              let name = Self.bundeslaender[paarIndex]?.1 else {
            return ""
        }
        return name
    }
    
    /// Koordinate für maximal einen Map-Marker der zuletzt relevanten Karte.
    var markerKoordinate: CLLocationCoordinate2D? {
        guard let paarIndex = paarIndexDerZuletztGewaehltenKarte,
              let koordinate = Self.bundeslaender[paarIndex]?.0 else {
            return nil
        }
        return koordinate
    }
    
    /// Ermittelt den Dictionary-Schlüssel der zuletzt gewählten, sichtbaren Karte.
    ///
    /// Marker-Strategie: Es gibt immer höchstens einen Marker. Dafür speichert das ViewModel
    /// die ID der zuletzt angetippten Karte. Nur wenn diese Karte noch aufgedeckt ist
    /// oder bereits als Paar geraten wurde, liefern `markerKoordinate` und `bundeslandName`
    /// einen Wert. Verdeckte, nicht mehr aktive Karten setzen den Marker zurück.
    private var paarIndexDerZuletztGewaehltenKarte: String? {
        guard let kartenId = zuletztGewaehlteKartenId,
              let karte = karten.first(where: { $0.id == kartenId }),
              karte.istGesichtOben || karte.istGeraten else {
            return nil
        }
        return Self.paarIndex(aus: kartenId)
    }
    
    /// Liest den paarIndex aus einer Karten-ID (z. B. „3a“ → „3“).
    private static func paarIndex(aus kartenId: String) -> String? {
        guard kartenId.count >= 2 else { return nil }
        return String(kartenId.dropLast())
    }
    
    /// Erzeugt ein neues 4x4-Spiel mit Flaggen-Bildern aus dem Bundesländer-Dictionary.
    private static func erzeugeMemoSpiel() -> MemoSpielModel<Image> {
        return MemoSpielModel<Image>(anzahlKartenPaare: 8) { paarIndex in
            if bundeslaender.keys.contains(String(paarIndex)) {
                if let landesName = bundeslaender[String(paarIndex)]?.1 {
                    return Image(landesName).resizable()
                }
            }
            return Image(systemName: "exclamationmark.questionmark").resizable()
        }
    }
    
    /// Intent: Startet ein komplett neues Spiel und setzt Marker-Bezug zurück.
    func neuesSpiel() {
        memoSpielModel = Self.erzeugeMemoSpiel()
        zuletztGewaehlteKartenId = nil
    }
    
    /// Intent: Karte antippen — delegiert die Spiel-Logik ans Model und merkt sich die Karte für den Marker.
    func waehleKarte(_ karte: MemoSpielModel<Image>.Karte) {
        var model = memoSpielModel
        model.waehle(karte)
        memoSpielModel = model
        zuletztGewaehlteKartenId = karte.id
    }
    
    /// Intent: Kartenpositionen neu mischen, ohne ein neues Spiel zu starten.
    func mischen() {
        var model = memoSpielModel
        model.shuffle()
        memoSpielModel = model
    }
}
