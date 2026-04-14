puts "Cleaning database..."
MenuItem.destroy_all
Restaurant.destroy_all

puts "Seeding restaurants..."

restaurant1 = Restaurant.create!(
  name: "The Golden Fork",
  address: "123 Main Street, Downtown",
  phone: "021-12345678",
  opening_hours: "08:00 - 22:00"
)

restaurant2 = Restaurant.create!(
  name: "Burger Barn",
  address: "456 Oak Avenue, Midtown",
  phone: "021-87654321",
  opening_hours: "10:00 - 23:00"
)

puts "Seeding menu items..."

restaurant1.menu_items.create!([
  { name: "Grilled Salmon", description: "Fresh salmon fillet with lemon butter sauce", price: 85000, category: "main", is_available: true },
  { name: "Caesar Salad", description: "Romaine lettuce with caesar dressing and croutons", price: 45000, category: "appetizer", is_available: true },
  { name: "Chocolate Lava Cake", description: "Warm chocolate cake with molten center", price: 35000, category: "dessert", is_available: true },
  { name: "Sparkling Lemonade", description: "Freshly squeezed lemonade with sparkling water", price: 25000, category: "drink", is_available: true },
  { name: "Beef Tenderloin", description: "Grilled beef tenderloin with mushroom sauce", price: 120000, category: "main", is_available: true }
])

restaurant2.menu_items.create!([
  { name: "Classic Cheeseburger", description: "Beef patty with cheddar cheese and fresh vegetables", price: 55000, category: "main", is_available: true },
  { name: "Crispy Onion Rings", description: "Golden fried onion rings with dipping sauce", price: 30000, category: "appetizer", is_available: true },
  { name: "Vanilla Milkshake", description: "Creamy vanilla milkshake topped with whipped cream", price: 35000, category: "drink", is_available: true },
  { name: "Banana Split", description: "Classic banana split with three scoops of ice cream", price: 40000, category: "dessert", is_available: true },
  { name: "BBQ Bacon Burger", description: "Double beef patty with crispy bacon and BBQ sauce", price: 75000, category: "main", is_available: true }
])

puts "Done! Seeded #{Restaurant.count} restaurants and #{MenuItem.count} menu items."
