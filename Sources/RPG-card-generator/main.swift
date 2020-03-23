import Foundation
import Files
import Rainbow
import AppKit

extension String {
    private func ignoreCase(other: String) -> Bool {
        return self.caseInsensitiveCompare(other) == .orderedSame
    }
    func equalsIgnoreCase(_ others: String...) -> Bool {
        for other in others {
            if self.ignoreCase(other: other) {
                return true
            }
        }
        return false
    }
    func orIfEmpty(_ other: String) -> String {
        if isEmpty {
            return other
        }
        return self
    }
    func beginsWith(_ other: String, ignoreCase: Bool) -> Bool {
        let sub = String(self.prefix(other.count))
        if ignoreCase {
            return sub.ignoreCase(other: other)
        }
        return sub == other
    }
}
var jsonObject: [[String: Any]] = []
func createSpell() {
    print("Creating a spell...")
    print("It's recommended that you make all of these lowercase, except for any components (such as [V, S])")
    print()
    print("Title?")
    let title = readLine()!
    print("Level?")
    let level = Int(readLine()!)!
    print("School? (first on list)")
    let school = readLine()!
    print("Casting time?")
    let castingTime = readLine()!
    print("Components?")
    let components = readLine()!
    print("Range?")
    let range = readLine()!
    print("Duration?")
    let duration = readLine()!
    print("Saving Throw?")
    let save = readLine()!
    print("Spell Resistance?")
    let sr = readLine()!
    print("Description? (some HTML [<b>, <i>] is allowed)")
    let desc = readLine()!
    print("Description line 2? (ignored if empty)")
    let desc2 = readLine()!
    print("Does the spell get better at higher levels?")
    var improves = (does: readLine()!.equalsIgnoreCase("y", "yes", "true"), how: "")
    if improves.does {
        print("Improvement description?")
        improves.how = readLine()!
    }
    print("You've finished, generating spell...")
    var content: [String] = []
    var levelExt: String = ""
    switch level % 10 {
    case 1: levelExt = "st"
    case 2: levelExt = "nd"
    case 3: levelExt = "rd"
    default: levelExt = "th"
    }
    content.append("subtitle | \(level)\(levelExt) level \(school)")
    content.append("rule")
    content.append("property | Casting Time | \(castingTime)")
    content.append("property | Components | \(components)")
    content.append("property | Range | \(range)")
    content.append("property | Duration | \(duration)")
    content.append("property | Saving Throw | \(save)")
    content.append("property | Spell Resistance | \(sr)")
    content.append("rule")
    content.append("fill")
    content.append("text | \(desc)")
    if !desc2.isEmpty {
        content.append("text | \(desc2)")
    }
    content.append("fill")
    if improves.does {
        content.append("section | At higher levels")
        content.append("text | \(improves.how)")
    }
    addCard(title: title, contents: content, tags: ["spell", "level\(level)"], icon_back: "robe", icon: "white-book-\(level)", titleSize: "16")
    print("Spell added to JSON")
}
func createWeapon() {
    print("Creating a weapon...")
//    print("It's recommended that you make all of these lowercase, except for any components (such as [V, S])")
    print()
    print("Title? (weapon type/name, i.e. 'Shortsword' or '", "+1 shortsword".italic, "' or '", "Brisingr".italic, "')", separator: "")
    let title = readLine()!
    print("Is the weapon a melee weapon? (without throwing)")
    let meleeOnly = readLine()!.equalsIgnoreCase("y", "yes", "true")
    if meleeOnly {
        print("Rarity? (simple, martial, exotic)")
        let rarity = readLine()!.capitalized
        print("Cost? (with GP, i.e. '500gp')")
        let cost = readLine()!
        print("Damage? (without type, i.e. '2d6')")
        let damage = readLine()!
        print("Damage type? (i.e. 'S' or 'slashing')")
        let damageType = readLine()!
        print("Critical threat? (e.g. '19-20'. If it isn't shown, it's '20')")
        let criticalThreat = readLine() ?? "20"
        print("Critical multiplier? (without the 'x', e.g. '2' instead of 'x2'. Generally '2')")
        let criticalMultiplier = Int(readLine() ?? "2") ?? 2
        print("Attack modifiers? (ability name, then abbr. Unless the modifier isn't STR, press return twice)")
        let attackMod = (name: readLine()!.orIfEmpty("Strength"), abbr: readLine()!.orIfEmpty("STR"))
        print("Damage modifiers? (ability name, then abbr. Unless the modifier isn't STR, press return twice)")
        let damageMod = (name: readLine()!.orIfEmpty("Strength"), abbr: readLine()!.orIfEmpty("STR"))
        print("Icon? (for swords, use 'broadsword'; for daggers, use 'plain-dagger'; for spears, use 'arrowhead'; for clubs, use 'wood-club')")
        let icon = readLine() ?? "crossed-swords"
        var content: [String] = []
        content.append("subtitle | \(rarity) melee weapon (\(cost))")
        content.append("rule")
        content.append("property | Damage | \(damage) \(damageType)")
        content.append("property | Critical | \(criticalThreat)/x\(criticalMultiplier)")
        content.append("property | Attack Modifier | \(attackMod.name)")
        content.append("property | Damage Modifier | \(damageMod.name)")
        content.append("rule")
        content.append("fill")
        content.append("description | Attack | Roll 1d20 + \(attackMod.abbr). If the result is greater than or equal to the target's AC, you hit.")
        content.append("description | Critical Hits | If you rolled a <b>natural</b> \(criticalThreat) on your attack roll, it's a <i>critical threat</i>. Roll again. If you hit, the critical hit is confirmed.")
        content.append("description | Damage | Roll \(damage) + \(damageMod.abbr). If you made a critical hit, roll \(criticalMultiplier - 1) more time\(criticalMultiplier != 2 ? "s" : "") and add the results together. The target takes this much damage.")
        content.append("fill")
        addCard(title: title, contents: content, tags: ["weapon", "melee"], icon_back: "crossed-swords", icon: icon, titleSize: "16")
        print("Weapon added to JSON")
    } else {
        print("Is the weapon a ranged weapon?")
        let rangedOnly = readLine()!.equalsIgnoreCase("y", "yes", "true")
        if rangedOnly {
            print("Rarity? (simple, martial, exotic)")
            let rarity = readLine()!.capitalized
            print("Cost? (with GP, i.e. '500gp')")
            let cost = readLine()!
            print("Damage? (without type, i.e. '1d8')")
            let damage = readLine()!
            print("Damage type? (i.e. 'P' or 'piercing')")
            let damageType = readLine()!
            print("Critical threat? (e.g. '19-20'. If it isn't shown, it's '20')")
            let criticalThreat = readLine() ?? "20"
            print("Critical multiplier? (without the 'x', e.g. '2' instead of 'x2'. Generally '2')")
            let criticalMultiplier = Int(readLine() ?? "2") ?? 2
            print("Attack modifiers? (ability name, then abbr. Unless the modifier isn't DEX, press return twice)")
            let attackMod = (name: readLine()!.orIfEmpty("Dexterity"), abbr: readLine()!.orIfEmpty("DEX"))
            print("Range? (e.g. '100ft')")
            let range = readLine()!
            print("Icon? (for bows, use 'bow-arrow'; for crossbows, use 'crossbow'; for slings, use 'slingshot')")
            let icon = readLine() ?? "crossed-swords"
            var content: [String] = []
            content.append("subtitle | \(rarity) ranged weapon (\(cost))")
            content.append("rule")
            content.append("property | Damage | \(damage) \(damageType)")
            content.append("property | Critical | \(criticalThreat)/x\(criticalMultiplier)")
            content.append("property | Attack Modifier | \(attackMod.name)")
            content.append("property | Range | \(range)")
            content.append("rule")
            content.append("fill")
            content.append("description | Attack | Roll 1d20 + \(attackMod.abbr). If the result is greater than or equal to the target's AC, you hit.")
            content.append("description | Critical Hits | If you rolled a <b>natural</b> \(criticalThreat) on your attack roll, it's a <i>critical threat</i>. Roll again. If you hit, the critical hit is confirmed.")
            content.append("description | Damage | Roll \(damage). If you made a critical hit, roll \(criticalMultiplier - 1) more time\(criticalMultiplier != 2 ? "s" : "") and add the results together. The target takes this much damage.")
            content.append("fill")
            addCard(title: title, contents: content, tags: ["weapon", "ranged"], icon_back: "crossed-swords", icon: icon, titleSize: "16")
            print("Weapon added to JSON")
        } else {
            print("Press return to confirm that this should be a throwable weapon (anything else cancels)")
            guard let l = readLine(), !l.isEmpty else {
                return
            }
            //TODO: Make thrown weapons
        }
    }
//    var content: [String] = []
//    let icon = "broadsword"
//    addCard(title: title, contents: content, tags: ["Weapon"], icon_back: "crossed-swords", icon: icon, titleSize: "16")
}
func createEquipment() {
    let icon = ["barbute", "breastplate", "visored-helm", "steeltoe-boots"]
}
func createArmor() {
    
}
func createEnemy() {
    
}
func createPotion() {
    print("Creating a potion...")
    print()
    print("Is it a ", "potion of healing".italic, "?", separator: "")
    let healing = readLine()!.equalsIgnoreCase("y", "yes", "true")
    if healing {
        enum PotionType {
            case light
            case moderate
            case serious
            var heal: String {
                switch self {
                case .light: return "1d8 + 1"
                case .moderate: return "2d8 + 3"
                case .serious: return "3d8 + 5"
                }
            }
            var name: String {
                switch self {
                case .light: return "Cure Light Wounds (50gp)"
                case .moderate: return "Cure Moderate Wounds (300gp)"
                case .serious: return "Cure Serious Wounds (750gp)"
                }
            }
        }
        print("Which type of healing potion is it? (light, moderate, serious)")
        let typeInput = readLine()!
        var type: PotionType
        if typeInput.equalsIgnoreCase("light") {
            type = .light
        } else if typeInput.equalsIgnoreCase("moderate") {
            type = .moderate
        } else if typeInput.equalsIgnoreCase("serious") {
            type = .serious
        } else {
            print("Invalid type, not creating potion")
            return
        }
        var content: [String] = []
        content.append("subtitle | \(type.name)")
        content.append("rule")
        content.append("property | Drinking time | 1 standard action")
        content.append("property | Hit points restored | \(type.heal)")
        content.append("rule")
        content.append("fill")
        content.append("text | When you drink this potion, you regain <b>\(type.heal) hitpoints</b>")
        content.append("text | Drinking this potion is a standard action.")
        content.append("text | Administering it to an unconscious creature is a full-round action.")
        content.append("fill")
        content.append("section | Undead Creatures")
        content.append("text | If an undead creature drinks this potion, they take damage instead. If this occurs, they can apply spell resistance and attempt a Will save to take half damage.")
        addCard(title: "Potion of Healing", contents: content, tags: ["potion"], icon_back: "drink-me", icon: "drink-me", titleSize: "16")
        print("Potion added to JSON")
    } else {
        print("Title?")
        let title = readLine()!
        print("Cost? (with GP, i.e. '500gp'")
        let cost = readLine()!
        print("Subtitle? (without price)")
        let subtitle = readLine()!
        print("Any properties?")
        let property = readLine()!.equalsIgnoreCase("y", "yes", "true")
        var properties: [String: String] = [:]
        if property {
            print("Name of property?")
            var propName = readLine()!
            var propValue: String = ""
            while(!propName.equalsIgnoreCase("quit", "done")) {
                print("Property '\(propName)' value?")
                propValue = readLine()!
                properties[propName] = propValue
                print("Name of property, or 'quit' if that was the last one?")
                propName = readLine()!
            }
        }
        print("Description? (some HTML [<b>, <i>] is allowed)")
        let desc = readLine()!
        print("Is there an extra section?")
        var section = (exists: readLine()!.equalsIgnoreCase("y", "yes", "true"), name: "", text: "")
        if section.exists {
            print("Section name?")
            section.name = readLine()!
            print("Section text?")
            section.text = readLine()!
        }
        var content: [String] = []
        content.append(subtitle + " (" + cost + ")")
        content.append("rule")
        if property {
            for (name, value) in properties {
                content.append("property | \(name) | \(value)")
            }
            content.append("rule")
        }
        content.append("fill")
        content.append("text | \(desc)")
        if section.exists {
            content.append("section | \(section.name)")
            content.append("text | \(section.text)")
        }
        addCard(title: title, contents: content, tags: ["potion"], icon_back: "drink-me", icon: "drink-me", titleSize: "16")
        print("Potion added to JSON")
    }
}
func createAmmunition() {
    print("Creating ammunition...")
    print()
    print("Are you adding any of the following: arrows, crossbow bolts, sling bullets, blowgun darts?")
    let standard = readLine()!.equalsIgnoreCase("y", "yes", "true")
    if standard {
        print("Which type?")
        let type = readLine()!
        if type.equalsIgnoreCase("arrow", "arrows") {
            addCard(title: "Arrow (20)", contents: [
                "subtitle | Ammunition (20pcs) (1gp)",
                "rule",
                "property | Usage | longbows, shortbows",
                "rule",
                "fill",
                "description | Longbow | Arrows are the standard ammunition for longbows.",
                "description | Composite Longbow | Arrows are the standard ammunition for composite longbows.",
                "description | Shortbow | Arrows are the standard ammunition for shortbows.",
                "description | Composite Shortbow | Arrows are the standard ammunition for composite shortbows .",
                "fill",
                "rule",
                "boxes | 20 | 1.66"
                ], tags: ["ammunition"], icon_back: "quiver", icon: "arrow-cluster", titleSize: "16")
        } else if type.equalsIgnoreCase("crossbow bolts", "crossbow bolt", "bolt", "bolts") {
            addCard(title: "Crossbow Bolts (10)", contents: [
                "subtitle | Ammunition (10pcs) (1gp)",
                "rule",
                "property | Usage | heavy crossbows, light crossbows, hand crossbows",
                "rule",
                "fill",
                "description | Heavy Crossbows | Crossbow bolts are the standard ammunition for heavy crossbows.",
                "description | Light Crossbows | Crossbow bolts are the standard ammunition for light crossbows.",
                "description | Hand Crossbows | Crossbow bolts are the standard ammunition for hand crossbows.",
                "fill",
                "rule",
                "boxes | 10 | 1.66"
                ], tags: ["ammunition"], icon_back: "quiver", icon: "arrow-cluster", titleSize: "16")
        } else if type.equalsIgnoreCase("sling bullet", "sling bullets", "bullet", "bullets") {
            addCard(title: "Sling Bullets (10)", contents: [
                "subtitle | Ammunition (10pcs) (1sp)",
                "rule",
                "property | Usage | slings, sling staffs",
                "rule",
                "fill",
                "description | Slings | Sling bullets are the standard ammunition for slings.",
                "description | Sling Staffs | Sling bullets are the standard ammunition for sling staffs.",
                "fill",
                "rule",
                "boxes | 10 | 1.66"
                ], tags: ["ammunition"], icon_back: "quiver", icon: "arrow-cluster", titleSize: "16")
        } else if type.equalsIgnoreCase("blowgun dart", "blowgun darts", "dart", "darts") {
            let icon = "dart"
        } else {
            print("Not recognized, canceling")
            return
        }
    }
}
func addCard(title: String, contents: [String], tags: [String], icon_back: String, icon: String, titleSize: String) {
    jsonObject.append(["count": 1, "title": title, "contents": contents, "tags": tags, "color": "black", "icon_back": icon_back, "icon": icon, "title_size": titleSize])
}

func save() {
    print("Output filename?")
    let fileName = readLine()!
    do {
        let jsonString = String(data: try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted), encoding: .utf8)!
        try Folder.current.createFileIfNeeded(withName: fileName).write(string: jsonString)
    } catch let error {
        print(error.localizedDescription)
        exit(1)
    }
}
func initializeRPGSTDLIB(_ completion: @escaping () -> () = {}) {
    let url = URL(string: "https://raw.githubusercontent.com/Samasaur1/RPG-card-generator/master/Sources/RPG-card-generator/RPGSTDLIB.json")!
    let sessionConfig = URLSessionConfiguration.default
    let session = URLSession(configuration: sessionConfig)
    let request = URLRequest(url: url)
    let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
        if let tempLocalUrl = tempLocalUrl, error == nil {
            // Success
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                print("Response error")
                return
            }
            guard (200..<300).contains(statusCode) else {
                print("Bad status code: \(statusCode)")
                return
            }
            
            do {
                let folder = try Folder.home.createSubfolderIfNeeded(withName: ".rpg-generator")
                try? folder.file(named: "RPGSTDLIB.json").delete() //delete old file if exists
                let file = try File(path: tempLocalUrl.path)
                try? file.parent?.file(named: "RPGSTDLIB.json").delete() //delete old file in temp directory if exists
                try file.rename(to: "RPGSTDLIB.json", keepExtension: false)
                try file.move(to: folder)
                
                print("Successfully initialized RPGSTDLIB")
                completion()
            } catch let writeError {
                print(writeError.localizedDescription)
            }
            
        } else {
            print("Failure: \(error!.localizedDescription)")
        }
    }
    task.resume()
}

if CommandLine.argc > 1, CommandLine.arguments[1] == "RPGSTDLIB" {
    let d = DispatchGroup()
    d.enter()
    initializeRPGSTDLIB {
        d.leave()
    }
    d.wait()
    exit(0)
}

main: while(true) {
    let input: String = readLine()!
    guard !input.isEmpty else {
        continue main
    }
    
    if input.equalsIgnoreCase("q", "quit", "exit") {
        print("Do you want to save?")
        if readLine()!.equalsIgnoreCase("y", "yes") {
            save()
        }
        break main//breaks `while(true)` loop
    } else if input.equalsIgnoreCase("c", "create", "create card", "create new", "create new card") {
        print("Type? (spell, weapon, enemy/villain, armor, equipment, potion)")
        let type = readLine()!
        if type.equalsIgnoreCase("spell") {
            createSpell()
        } else if type.equalsIgnoreCase("weapon") {
            createWeapon()
        } else if type.equalsIgnoreCase("enemy", "villain") {
            createEnemy()
        } else if type.equalsIgnoreCase("armor", "armour") {
            createArmor()
        } else if type.equalsIgnoreCase("equipment") {
            createEquipment()
        } else if type.equalsIgnoreCase("potion") {
            createPotion()
        } else if type.equalsIgnoreCase("ammunition", "ammo") {
            createAmmunition()
        } else {
            print("Not recognized, not creating")
            continue main
        }
    } else if input.equalsIgnoreCase("a", "add", "add card", "add new", "add new card") {
        var cards: [[String: Any]] = []
        
        //Add local library cards
        if let localLib = try? Folder.home.subfolder(named: ".rpg-generator").subfolder(named: "local-library") {
            for file in localLib.files {
                do {
                    let json = try JSONSerialization.jsonObject(with: Data(contentsOf: URL(fileURLWithPath: file.path))) as! [[String: Any]]
                    cards.append(contentsOf: json)
                }
            }
        } else {
            print("Could not read local library")
        }
        
        //Add RPGSTDLIB cards
        if let stdlib = try? Folder.home.subfolder(named: ".rpg-generator").file(named: "RPGSTDLIB.json") {
            let json = try! JSONSerialization.jsonObject(with: Data(contentsOf: URL(fileURLWithPath: stdlib.path))) as! [[String: Any]]
            cards.append(contentsOf: json)
        } else {
            print("Could not read RPGSTDLIB (RPG standard library)")
            print("Run '\(ProcessInfo.processInfo.arguments[0]) RPGSTDLIB' to initialize RPGSTDLIB")
        }
        
        print()
        print("Premade cards:".bold + " (custom cards are listed before RPGSTDLIB cards)")
        for card in cards {
            print(card["title"]! as! String)
        }
        print()
        print("Choose a card or type a term to search for")
        print("If the input doesn't match a card, it will search")
        let cardInput = readLine()!
        for card in cards {
            if card["title"]! as! String == cardInput {
                jsonObject.append(card)
                print("Added '\(card["title"]! as! String)'")
                continue main
            }
        }
        for card in cards {
            if (card["title"]! as! String).equalsIgnoreCase(cardInput) {
                jsonObject.append(card)
                print("Added '\(card["title"]! as! String)'")
                continue main
            }
        }
        print()
        print("No matching card, searching for '\(cardInput)'...".bold)
        for card in cards {
            if (card["title"]! as! String).beginsWith(cardInput, ignoreCase: false) {
                print(card["title"]! as! String)
            }
        }
        for card in cards {
            if (card["title"]! as! String).beginsWith(cardInput, ignoreCase: true) && !(card["title"]! as! String).beginsWith(cardInput, ignoreCase: false) {
                print(card["title"]! as! String)
            }
        }
    } else if input.equalsIgnoreCase("n", "new", "new card") {
        print("Would you like to add a file from the library (either the standard library or the local library), or create a new card?")
        print("To add a card from the library, use 'add' or 'a'")
        print("To create a new card, use 'create' or 'c'")
    } else if input.equalsIgnoreCase("l", "list", "list card", "list cards") {
        print("JSON so far:")
        print()
        print(String(data: try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted), encoding: .utf8)!)
        print()
        print("Cards:")
        for card in jsonObject {
            print(card["title"]!)
        }
    } else if input.equalsIgnoreCase("h", "help") {
        print("The available commands are:")
        print("quit, create, add, new, list, help, library")
    } else if input.equalsIgnoreCase("library") {
        print("What do you want to do to the library? (list, add, remove, clear, load)")
        let subtask = readLine()!
        if subtask.equalsIgnoreCase("list") {
            do {
                let folder = try Folder.home.createSubfolderIfNeeded(withName: ".rpg-generator").createSubfolderIfNeeded(withName: "local-library")
                for file in folder.files {
                    print(file.nameExcludingExtension)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        } else if subtask.equalsIgnoreCase("add") {
            print("What would you like to add? (file, paste, current)")
            let source = readLine()!
            if source.equalsIgnoreCase("file") {
                print("File path?")
                let path = readLine()!
                do {
                    try File(path: path).copy(to: Folder.home.createSubfolderIfNeeded(withName: ".rpg-generator").createSubfolderIfNeeded(withName: "local-library"))
                } catch let error {
                    print(error.localizedDescription)
                }
            } else if source.equalsIgnoreCase("paste") {
                print("Confirm adding:")
                let d = NSPasteboard.general.data(forType: .string)!
                let s = String(data: d, encoding: .utf8)!
                print(s)
                print()
                print("Type 'n' or 'no' to cancel")
                if readLine()!.equalsIgnoreCase("n", "no") {
                    continue main
                }
                print("Filename? (with .json)")
                let name = readLine()!
                do {
                    let json = try JSONSerialization.jsonObject(with: d) as! [String: Any]
                    try Folder.home.createSubfolderIfNeeded(withName: ".rpg-generator").createSubfolderIfNeeded(withName: "local-library").createFile(named: name, contents: JSONSerialization.data(withJSONObject: json))
                } catch let error {
                    print(error.localizedDescription)
                }
            } else if source.equalsIgnoreCase("current") {
                print("Filename? (with .json)")
                let name = readLine()!
                do {
                    try Folder.home.createSubfolderIfNeeded(withName: ".rpg-generator").createSubfolderIfNeeded(withName: "local-library").createFile(named: name, contents: JSONSerialization.data(withJSONObject: jsonObject))
                } catch let error {
                    print(error.localizedDescription)
                }
            } else {
                print("Source \(source) not recognized")
            }
        } else if subtask.equalsIgnoreCase("remove") {
            print("Which file would you like to remove?")
            let fileToDel = readLine()!
            do {
                let folder = try Folder.home.createSubfolderIfNeeded(withName: ".rpg-generator").createSubfolderIfNeeded(withName: "local-library")
                for file in folder.files.filter({ $0.nameExcludingExtension == fileToDel }) {
                    try file.delete()
                    print("File '\(file.nameExcludingExtension)' deleted")
                }
            } catch let error {
                print(error.localizedDescription)
            }
        } else if subtask.equalsIgnoreCase("clear") {
            do {
                let folder = try Folder.home.createSubfolderIfNeeded(withName: ".rpg-generator").createSubfolderIfNeeded(withName: "local-library")
                for file in folder.files {
                    try file.delete()
                    print("File '\(file.nameExcludingExtension)' deleted")
                }
                print("Files cleared")
            } catch let error {
                print(error.localizedDescription)
            }
        } else if subtask.equalsIgnoreCase("load") {
            initializeRPGSTDLIB()
        } else {
            print("'\(subtask)' is unrecognized")
        }
    } else {
        print("'\(input)' is unrecognized")
        print("Type 'help' to see available commands")
    }
    print()
}
