irb(main):006:0> Brewery.create name:"BrewDog", year:2007
   (0.1ms)  begin transaction
  SQL (0.2ms)  INSERT INTO "breweries" ("name", "year", "created_at", "updated_at") VALUES (?, ?, ?, ?)  [["name", "BrewDog"], ["year", 2007], ["created_at", "2017-01-04 18:04:20.737784"], ["updated_at", "2017-01-04 18:04:20.737784"]]
   (8.8ms)  commit transaction
=> #<Brewery id: 4, name: "BrewDog", year: 2007, created_at: "2017-01-04 18:04:20", updated_at: "2017-01-04 18:04:20">

irb(main):007:0> b = _
=> #<Brewery id: 4, name: "BrewDog", year: 2007, created_at: "2017-01-04 18:04:20", updated_at: "2017-01-04 18:04:20">
irb(main):008:0> a = Beer.create name:"Punk IPA", style:"IPA"
   (0.1ms)  begin transaction
  SQL (0.4ms)  INSERT INTO "beers" ("name", "style", "created_at", "updated_at") VALUES (?, ?, ?, ?)  [["name", "Punk IPA"], ["style", "IPA"], ["created_at", "2017-01-04 18:05:07.148182"], ["updated_at", "2017-01-04 18:05:07.148182"]]
   (9.0ms)  commit transaction
=> #<Beer id: 8, name: "Punk IPA", style: "IPA", brewery_id: nil, created_at: "2017-01-04 18:05:07", updated_at: "2017-01-04 18:05:07">
irb(main):010:0> a.brewery = b
=> #<Brewery id: 4, name: "BrewDog", year: 2007, created_at: "2017-01-04 18:04:20", updated_at: "2017-01-04 18:04:20">

irb(main):018:0> a = Beer.create name:"Nanny State", style:"lowalcohol"
   (0.1ms)  begin transaction
  SQL (0.3ms)  INSERT INTO "beers" ("name", "style", "created_at", "updated_at") VALUES (?, ?, ?, ?)  [["name", "Nanny State"], ["style", "lowalcohol"], ["created_at", "2017-01-04 18:06:18.390091"], ["updated_at", "2017-01-04 18:06:18.390091"]]
   (9.4ms)  commit transaction
=> #<Beer id: 9, name: "Nanny State", style: "lowalcohol", brewery_id: nil, created_at: "2017-01-04 18:06:18", updated_at: "2017-01-04 18:06:18">
irb(main):019:0> a.brewery = b
=> #<Brewery id: 4, name: "BrewDog", year: 2007, created_at: "2017-01-04 18:04:20", updated_at: "2017-01-04 18:04:20">
