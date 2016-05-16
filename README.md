<h1 align="center">Plastic</h1>

<p align="center">
  <img src="http://emojipedia-us.s3.amazonaws.com/cache/26/9a/269a5bacd4afc699e47a6ddea49b592d.png" width=60 height=60>
</p>
<p align="center">
  Luhn validation and card types for credit/debit card numbers
</p>
<p align="center">
    <a href="https://developer.apple.com/swift/" ><img src="https://img.shields.io/badge/Swift-2.2-orange.svg?style=flat"></a>
    <img src="https://img.shields.io/badge/platform-iOS%208%2B-blue.svg?style=flat" alt="Platform: iOS 8+">
    <a href="https://travis-ci.org/LootApp/Plastic"><img src="https://travis-ci.org/LootApp/Plastic.svg?branch=master"></a>
    <a href="https://codecov.io/github/LootApp/Plastic?branch=master"><img src="https://codecov.io/github/LootApp/Plastic/coverage.svg?branch=master"></a>
    <img src="https://img.shields.io/badge/package%20managers-SPM%20%7C%20Carthage-yellow.svg">
</p>

<br>

<p align="center">
  Here are some useful resources on the Luhn algorithm: <br>

  https://en.wikipedia.org/wiki/Luhn_algorithm <br>
  https://www.rosettacode.org/wiki/Luhn_test_of_credit_card_numbers
</p>

<br>

<p align="center">
  Thank you to <a href="https://twitter.com/MaxKramer">Max Kramer</a> for the <a href="https://github.com/maxkramer/objectiveluhn">initial inspiration</a>.
</p>


<br>
<br>

## Features

- Check the type of a card number (Amex, DinersClub, Discover, JCB, MasterCard or Visa)
- Check if a given card number is valid

## Usage

```swift
let cardNumber = "3782 822463 10005"
let isValid = cardNumber.plastic_luhnValidate()
do {
    print(try cardNumber.plastic_cardType()) // Prints "Amex" in the console
} catch {
    // Handle error
    // Only error that Plastic throws is PlasticError.InvalidCardNumber
    // Thrown if the card number is < 9 digits and not Luhn valid
}
```

## Tests

[Test card numbers](https://github.com/LootApp/Plastic/blob/master/PlasticTests/TestCardNumbers.plist) are [from PayPal](http://www.paypalobjects.com/en_US/vhelp/paypalmanager_help/credit_card_numbers.htm).
