#include <LiquidCrystal.h>
#include <Button.h>

int friends = 0;
unsigned int rpm;
unsigned long timeold;

//create object to control an LCD GMD1602K.
LiquidCrystal lcd(12, 11, 5, 4, 3, 2);
const int numRows = 2;
const int numCols = 16;
Button button = Button(8, PULLUP);

void setup() {
  lcd.begin(numRows, numCols);
}

void loop() {
  lcd.setCursor(0, 0);
  lcd.print("Friend Hunter: Me");
  lcd.setCursor(0, 1);
  lcd.print("Add: ");
  lcd.print(friends);
  lcd.print(" friends");
  if (button.uniquePress()) {
    friends++;
  }
  delay(200);
}
