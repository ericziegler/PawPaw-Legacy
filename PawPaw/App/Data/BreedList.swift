//
//  BreedList.swift
//  PawPaw
//
//  Created by Eric Ziegler on 11/1/17.
//  Copyright © 2017 zigabytes. All rights reserved.
//

import Foundation

let CatBreeds = "Abyssinian,American Curl,American Shorthair,American Wirehair,Applehead Siamese,Balinese,Bengal,Birman,Bobtail,Bombay,British Shorthair,Burmese,Burmilla,Calico,Canadian Hairless,Chartreux,Chausie,Chinchilla,Cornish Rex,Cymric,Devon Rex,Dilute Calico,Dilute Tortoiseshell,Domestic Long Hair,Domestic Long Hair (Black & White),Domestic Long Hair (Black),Domestic Long Hair (Brown),Domestic Long Hair (Buff & White),Domestic Long Hair (Buff),Domestic Long Hair (Gray & White),Domestic Long Hair (Gray),Domestic Long Hair (Orange & White),Domestic Long Hair (Orange),Domestic Long Hair (White),Domestic Medium Hair,Domestic Medium Hair (Black & White),Domestic Medium Hair (Black),Domestic Medium Hair (Brown),Domestic Medium Hair (Buff & White),Domestic Medium Hair (Buff),Domestic Medium Hair (Gray & White),Domestic Medium Hair (Gray),Domestic Medium Hair (Orange & White),Domestic Medium Hair (Orange),Domestic Medium Hair (White),Domestic Short Hair,Domestic Short Hair (Black & White),Domestic Short Hair (Black),Domestic Short Hair (Brown),Domestic Short Hair (Buff & White),Domestic Short Hair (Buff),Domestic Short Hair (Gray & White),Domestic Short Hair (Gray),Domestic Short Hair (Mitted),Domestic Short Hair (Orange & White),Domestic Short Hair (Orange),Domestic Short Hair (White),Egyptian Mau,Exotic Shorthair,Extra-Toes Cat / Hemingway Polydactyl,Havana,Himalayan,Japanese Bobtail,Javanese,Korat,LaPerm,Maine Coon,Manx,Munchkin,Nebelung,Norwegian Forest Cat,Ocicat,Oriental Long Hair,Oriental Short Hair,Oriental Tabby,Persian,Pixie-Bob,Ragamuffin,Ragdoll,Russian Blue,Scottish Fold,Selkirk Rex,Siamese,Siberian,Silver,Singapura,Snowshoe,Somali,Sphynx / Hairless Cat,Tabby,Tabby (Black),Tabby (Brown),Tabby (Buff),Tabby (Gray),Tabby (Orange),Tabby (White),Tiger,Tonkinese,Torbie,Tortoiseshell,Turkish Angora,Turkish Van,Tuxedo"
let DogBreeds = "Affenpinscher,Afghan Hound,Airedale Terrier,Akbash,Akita,Alaskan Malamute,American Bulldog,American Eskimo Dog,American Hairless Terrier,American Staffordshire Terrier,American Water Spaniel,Anatolian Shepherd,Appenzell Mountain Dog,Australian Cattle Dog / Blue Heeler,Australian Kelpie,Australian Shepherd,Australian Terrier,Basenji,Basset Hound,Beagle,Bearded Collie,Beauceron,Bedlington Terrier,Belgian Shepherd / Laekenois,Belgian Shepherd / Malinois,Belgian Shepherd / Sheepdog,Belgian Shepherd / Tervuren,Bernese Mountain Dog,Bichon Frise,Black and Tan Coonhound,Black Labrador Retriever,Black Mouth Cur,Black Russian Terrier,Bloodhound,Blue Lacy,Bluetick Coonhound,Boerboel,Bolognese,Border Collie,Border Terrier,Borzoi,Boston Terrier,Bouvier des Flanders,Boxer,Boykin Spaniel,Briard,Brittany Spaniel,Brussels Griffon,Bull Terrier,Bullmastiff,Cairn Terrier,Canaan Dog,Cane Corso Mastiff,Carolina Dog,Catahoula Leopard Dog,Cattle Dog,Caucasian Sheepdog / Caucasian Ovtcharka,Cavalier King Charles Spaniel,Chesapeake Bay Retriever,Chihuahua,Chinese Crested Dog,Chinese Foo Dog,Chinook,Chocolate Labrador Retriever,Chow Chow,Cirneco dell'Etna,Clumber Spaniel,Cockapoo,Cocker Spaniel,Collie,Coonhound,Corgi,Coton de Tulear,Curly-Coated Retriever,Dachshund,Dalmatian,Dandi Dinmont Terrier,Doberman Pinscher,Dogo Argentino,Dogue de Bordeaux,Dutch Shepherd,English Bulldog,English Cocker Spaniel,English Coonhound,English Pointer,English Setter,English Shepherd,English Springer Spaniel,English Toy Spaniel,Entlebucher,Eskimo Dog,Feist,Field Spaniel,Fila Brasileiro,Finnish Lapphund,Finnish Spitz,Flat-Coated Retriever,Fox Terrier,Foxhound,French Bulldog,Galgo Spanish Greyhound,German Pinscher,German Shepherd Dog,German Shorthaired Pointer,German Spitz,German Wirehaired Pointer,Giant Schnauzer,Glen of Imaal Terrier,Golden Retriever,Gordon Setter,Great Dane,Great Pyrenees,Greater Swiss Mountain Dog,Greyhound,Hamiltonstovare,Harrier,Havanese,Hound,Hovawart,Husky,Ibizan Hound,Icelandic Sheepdog,Illyrian Sheepdog,Irish Setter,Irish Terrier,Irish Water Spaniel,Irish Wolfhound,Italian Greyhound,Italian Spinone,Jack Russell Terrier,Jack Russell Terrier (Parson),Japanese Chin,Jindo,Kai Dog,Karelian Bear Dog,Keeshond,Kerry Blue Terrier,Kishu,Klee Kai,Komondor,Kuvasz,Kyi Leo,Labrador Retriever,Lakeland Terrier,Lancashire Heeler,Leonberger,Lhasa Apso,Lowchen,Maltese,Manchester Terrier,Maremma Sheepdog,Mastiff,McNab,Miniature Pinscher,Miniature Schnauzer,Mixed Breed,Mountain Cur,Mountain Dog,Munsterlander,Neapolitan Mastiff,New Guinea Singing Dog,Newfoundland Dog,Norfolk Terrier,Norwegian Buhund,Norwegian Elkhound,Norwegian Lundehund,Norwich Terrier,Nova Scotia Duck Tolling Retriever,Old English Sheepdog,Otterhound,Papillon,Patterdale Terrier / Fell Terrier,Pekingese,Peruvian Inca Orchid,Petit Basset Griffon Vendeen,Pharaoh Hound,Pit Bull Terrier,Plott Hound,Podengo Portugueso,Pointer,Polish Lowland Sheepdog,Pomeranian,Poodle,Portuguese Water Dog,Presa Canario,Pug,Puli,Pumi,Rat Terrier,Redbone Coonhound,Retriever,Rhodesian Ridgeback,Rottweiler,Rough Collie,Saint Bernard / St. Bernard,Saluki,Samoyed,Sarplaninac,Schipperke,Schnauzer,Scottish Deerhound,Scottish Terrier Scottie,Sealyham Terrier,Setter,Shar Pei,Sheep Dog,Shepherd,Shetland Sheepdog Sheltie,Shiba Inu,Shih Tzu,Siberian Husky,Silky Terrier,Skye Terrier,Sloughi,Smooth Collie,Smooth Fox Terrier,South Russian Ovtcharka,Spaniel,Spanish Water Dog,Spitz,Staffordshire Bull Terrier,Standard Poodle,Standard Schnauzer,Sussex Spaniel,Swedish Vallhund,Terrier,Thai Ridgeback,Tibetan Mastiff,Tibetan Spaniel,Tibetan Terrier,Tosa Inu,Toy Fox Terrier,Treeing Walker Coonhound,Vizsla,Weimaraner,Welsh Corgi,Welsh Springer Spaniel,Welsh Terrier,West Highland White Terrier / Westie,Wheaten Terrier,Whippet,White German Shepherd,Wire Fox Terrier,Wirehaired Dachshund,Wirehaired Pointing Griffon,Wirehaired Terrier,Xoloitzcuintle / Mexican Hairless,Yellow Labrador Retriever,Yorkshire Terrier Yorkie"

class BreedList {

    // MARK: Properties
    
    var catBreeds = [String : [String]]()
    var dogBreeds = [String : [String]]()
    
    // MARK: Init
    
    static let shared = BreedList()
    
    init() {
        var curLetter = ""
        
        let tempCatBreeds = CatBreeds.components(separatedBy: ",")
        for curCatBreed in tempCatBreeds {
            curLetter = String(curCatBreed.first!)
            if self.catBreeds[curLetter] == nil {
                catBreeds[curLetter] = [String]()
            }
            catBreeds[curLetter]?.append(curCatBreed)
        }
        
        curLetter = ""
        let tempDogBreeds = DogBreeds.components(separatedBy: ",")
        for curDogBreed in tempDogBreeds {
            curLetter = String(curDogBreed.first!)
            if self.dogBreeds[curLetter] == nil {
                dogBreeds[curLetter] = [String]()
            }
            dogBreeds[curLetter]?.append(curDogBreed)
        }
    }

    static func loadBreeds() {
        PetFinderAPI.shared.requestBreedsFor(type: .dog) { (json, error) in
            if error == nil && json != nil{
                print(json!)
            }
        }
    }
    
}
