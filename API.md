# API Documentation

### Quick Links

- [`vizlib.colors`]
- [`vizlib.select_color()`]
- [`vizlib.random_color()`]
- [`vizlib.draw_circle(pos, radius, axis, options)`]
- [`vizlib.draw_sphere(pos, radius, options)`]
- [`vizlib.draw_line(pos1, pos2, options)`]
- [`vizlib.draw_square(pos, radius, axis, options)`]
- [`vizlib.draw_cube(pos, radius, options)`]
- [`vizlib.draw_area(pos1, pos2, options)`]
- [`vizlib.clear_particles(ids)`]

## Colors

#### **`vizlib.colors`**

Provides a list of 24 colors, sorted by hue. Each value is a table containing two values:
- `name` - The name of the color, in lowercase.
- `hex` - The RGB hex code for the color, including the `#` prefix.

#### **`vizlib.select_color()`**

Selects a random color from `vizlib.colors`. Returns a hex color code, including the `#` prefix.

#### **`vizlib.select_color()`**

Generates a completely random color. Returns a hex color code, including the `#` prefix.


## Drawing

## Utility