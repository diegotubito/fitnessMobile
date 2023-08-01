//
//  ColorAsset.swift
//  HayEquipo
//
//  Created by David Gomez on 03/06/2023.
//

import SwiftUI

/// A convenience for accessing the bundle of a module or appropriate bundle
public final class BundleToken {
  public static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}


public final class ColorAsset {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  public private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  public func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  public private(set) lazy var swiftUIColor: SwiftUI.Color = {
    SwiftUI.Color(asset: self)
  }()
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

public extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
public extension SwiftUI.Color {
  init(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }
}
#endif


public enum Asset {
   
    public enum Colors {
        public enum Apricot {
            public static let lightApricot = ColorAsset(name: "LightApricot")
            public static let mediumApricot = ColorAsset(name: "MediumApricot")
            public static let midnightApricot = ColorAsset(name: "MidnightApricot")
            public static let trueApricot = ColorAsset(name: "TrueApricot")
            public static let washApricot = ColorAsset(name: "WashApricot")
            public static let allColors: [ColorAsset] = [
                lightApricot,
                mediumApricot,
                midnightApricot,
                trueApricot,
                washApricot,
            ]
        }
        public enum Blue {
            public static let lightBlue = ColorAsset(name: "LightBlue")
            public static let mediumBlue = ColorAsset(name: "MediumBlue")
            public static let midnightBlue = ColorAsset(name: "MidnightBlue")
            public static let trueBlue = ColorAsset(name: "TrueBlue")
            public static let washBlue = ColorAsset(name: "WashBlue")
            public static let allColors: [ColorAsset] = [
                lightBlue,
                mediumBlue,
                midnightBlue,
                trueBlue,
                washBlue,
            ]
        }
        public enum Chartreuse {
            public static let lightChartreuse = ColorAsset(name: "LightChartreuse")
            public static let mediumChartreuse = ColorAsset(name: "MediumChartreuse")
            public static let midnightChartreuse = ColorAsset(name: "MidnightChartreuse")
            public static let trueChartreuse = ColorAsset(name: "TrueChartreuse")
            public static let washChartreuse = ColorAsset(name: "WashChartreuse")
            public static let allColors: [ColorAsset] = [
                lightChartreuse,
                mediumChartreuse,
                midnightChartreuse,
                trueChartreuse,
                washChartreuse,
            ]
        }
        public enum Green {
            public static let lightGreen = ColorAsset(name: "LightGreen")
            public static let mediumGreen = ColorAsset(name: "MediumGreen")
            public static let midnightGreen = ColorAsset(name: "MidnightGreen")
            public static let trueGreen = ColorAsset(name: "TrueGreen")
            public static let washGreen = ColorAsset(name: "WashGreen")
            public static let allColors: [ColorAsset] = [
                lightGreen,
                mediumGreen,
                midnightGreen,
                trueGreen,
                washGreen,
            ]
        }
        public enum Neutral {
            public static let black = ColorAsset(name: "Black")
            public static let border = ColorAsset(name: "Border")
            public static let clear = ColorAsset(name: "Clear")
            public static let grayText = ColorAsset(name: "GrayText")
            public static let placeholder = ColorAsset(name: "Placeholder")
            public static let wash = ColorAsset(name: "Wash")
            public static let white = ColorAsset(name: "White")
            public static let allColors: [ColorAsset] = [
                black,
                border,
                clear,
                grayText,
                placeholder,
                wash,
                white,
            ]
        }
        public enum Overlay {
            public static let black15 = ColorAsset(name: "Black15")
            public static let black30 = ColorAsset(name: "Black30")
            public static let black4 = ColorAsset(name: "Black4")
            public static let black50 = ColorAsset(name: "Black50")
            public static let black80 = ColorAsset(name: "Black80")
            public static let white20 = ColorAsset(name: "White20")
            public static let white30 = ColorAsset(name: "White30")
            public static let white50 = ColorAsset(name: "White50")
            public static let white8 = ColorAsset(name: "White8")
            public static let white80 = ColorAsset(name: "White80")
            public static let allColors: [ColorAsset] = [
                black15,
                black30,
                black4,
                black50,
                black80,
                white20,
                white30,
                white50,
                white8,
                white80,
            ]
        }
        public enum Red {
            public static let lightRed = ColorAsset(name: "LightRed")
            public static let mediumRed = ColorAsset(name: "MediumRed")
            public static let midnightRed = ColorAsset(name: "MidnightRed")
            public static let trueRed = ColorAsset(name: "TrueRed")
            public static let washRed = ColorAsset(name: "WashRed")
            public static let allColors: [ColorAsset] = [
                lightRed,
                mediumRed,
                midnightRed,
                trueRed,
                washRed,
            ]
        }
        public enum Seafoam {
            public static let lightSeafoam = ColorAsset(name: "LightSeafoam")
            public static let mediumSeafoam = ColorAsset(name: "MediumSeafoam")
            public static let midnightSeafoam = ColorAsset(name: "MidnightSeafoam")
            public static let trueSeafoam = ColorAsset(name: "TrueSeafoam")
            public static let washSeafoam = ColorAsset(name: "WashSeafoam")
            public static let allColors: [ColorAsset] = [
                lightSeafoam,
                mediumSeafoam,
                midnightSeafoam,
                trueSeafoam,
                washSeafoam,
            ]
        }
        public enum Violet {
            public static let lightViolet = ColorAsset(name: "LightViolet")
            public static let mediumViolet = ColorAsset(name: "MediumViolet")
            public static let midnightViolet = ColorAsset(name: "MidnightViolet")
            public static let trueViolet = ColorAsset(name: "TrueViolet")
            public static let washViolet = ColorAsset(name: "WashViolet")
            public static let allColors: [ColorAsset] = [
                lightViolet,
                mediumViolet,
                midnightViolet,
                trueViolet,
                washViolet,
            ]
        }
        public enum Yellow {
            public static let lightYellow = ColorAsset(name: "LightYellow")
            public static let mediumYellow = ColorAsset(name: "MediumYellow")
            public static let midnightYellow = ColorAsset(name: "MidnightYellow")
            public static let trueYellow = ColorAsset(name: "TrueYellow")
            public static let washYellow = ColorAsset(name: "WashYellow")
            public static let allColors: [ColorAsset] = [
                lightYellow,
                mediumYellow,
                midnightYellow,
                trueYellow,
                washYellow,
            ]
        }
        public static let allColors: [ColorAsset] = [
            Apricot.lightApricot,
            Apricot.mediumApricot,
            Apricot.midnightApricot,
            Apricot.trueApricot,
            Apricot.washApricot,
            Blue.lightBlue,
            Blue.mediumBlue,
            Blue.midnightBlue,
            Blue.trueBlue,
            Blue.washBlue,
            Chartreuse.lightChartreuse,
            Chartreuse.mediumChartreuse,
            Chartreuse.midnightChartreuse,
            Chartreuse.trueChartreuse,
            Chartreuse.washChartreuse,
            Green.lightGreen,
            Green.mediumGreen,
            Green.midnightGreen,
            Green.trueGreen,
            Green.washGreen,
            Neutral.black,
            Neutral.border,
            Neutral.clear,
            Neutral.grayText,
            Neutral.placeholder,
            Neutral.wash,
            Neutral.white,
            Overlay.black15,
            Overlay.black30,
            Overlay.black4,
            Overlay.black50,
            Overlay.black80,
            Overlay.white20,
            Overlay.white30,
            Overlay.white50,
            Overlay.white8,
            Overlay.white80,
            Red.lightRed,
            Red.mediumRed,
            Red.midnightRed,
            Red.trueRed,
            Red.washRed,
            Seafoam.lightSeafoam,
            Seafoam.mediumSeafoam,
            Seafoam.midnightSeafoam,
            Seafoam.trueSeafoam,
            Seafoam.washSeafoam,
            Violet.lightViolet,
            Violet.mediumViolet,
            Violet.midnightViolet,
            Violet.trueViolet,
            Violet.washViolet,
            Yellow.lightYellow,
            Yellow.mediumYellow,
            Yellow.midnightYellow,
            Yellow.trueYellow,
            Yellow.washYellow,
        ]
    }
}
