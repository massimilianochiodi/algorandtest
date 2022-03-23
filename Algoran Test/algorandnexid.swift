//
//  algorandnexid.swift
//  Algoran Test
//
//  Created by Massimiliano Chiodi on 23/03/22.
//


import Foundation
import swift_algorand_sdk

public class AlgorandNexid: NSObject {
    
    public var wallet: Account?
    
    /// Genera il wallet dalle mnemonics
    public func generawalletdamnemonics(mnemonics: String) -> Account? {
        var provvisorioaccount: Account?
        
        do {
            
            provvisorioaccount = try Account(mnemonics)
            
        } catch {
            //TODO: Restituisci un errore
            let errore = error
            print(errore.localizedDescription)
        }
        
        
        return provvisorioaccount
    }
    
    public func dammiIndirizzoWallet(wallet: Account?) -> String? {
        var provvisorioaccount: Account?
        if let ilwallet: Account = wallet {
            provvisorioaccount = ilwallet
        } else {
            if let ilwalletGenerale = self.wallet {
                provvisorioaccount = ilwalletGenerale
            }
        }
        return provvisorioaccount?.address.description
    }
    
    public func signTX (wallet: Account?, message: String) -> String {
        var provvisorioaccount: Account?
        if let ilwallet: Account = wallet {
            provvisorioaccount = ilwallet
        } else {
            if let ilwalletGenerale = self.wallet {
                provvisorioaccount = ilwalletGenerale
            }
        }
        
        // firmo il messaggio
        let data = message.data.hexEncodedString()
        let databytes = getInt8(mappa: data.bytes)
        let risposta: Signature = provvisorioaccount!.rawSignBytes(bytes: databytes)
        
        let tx = getUInt8(mappa: risposta.bytes!)
        let ildatotx = Data(tx)
        return ildatotx.hexEncodedString(options: .upperCase)
    }
    
    func getInt8(mappa: [UInt8]) -> [Int8] {
        return mappa.map { Int8(bitPattern: $0) }
   }
    
    func getUInt8(mappa: [Int8]) -> [UInt8] {
        return mappa.map { UInt8(bitPattern: $0)}
    }
}



extension Data {
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }

    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return map { String(format: format, $0) }.joined()
    }
}

extension Array {
    func contiene<T>(obj: T) -> Bool where T: Equatable {
        return !self.filter({$0 as? T == obj}).isEmpty
    }
}
