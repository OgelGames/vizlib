# API Documentation

### Quick Links

- [`vizlib.colors`](#vizlibcolors)
- [`vizlib.select_color()`](#vizlibselect_color)
- [`vizlib.random_color()`](#vizlibrandom_color)
- [`vizlib.draw_circle(pos, radius, axis, options)`](#vizlibdraw_circlepos-radius-axis-options)
- [`vizlib.draw_sphere(pos, radius, options)`](#vizlibdraw_spherepos-radius-options)
- [`vizlib.draw_line(pos1, pos2, options)`](#vizlibdraw_linepos1-pos2-options)
- [`vizlib.draw_square(pos, radius, axis, options)`](#vizlibdraw_squarepos-radius-axis-options)
- [`vizlib.draw_cube(pos, radius, options)`](#vizlibdraw_cubepos-radius-options)
- [`vizlib.draw_area(pos1, pos2, options)`](#vizlibdraw_areapos1-pos2-options)
- [`vizlib.erase_shape(shape)`](#vizliberase_shapeshape)

## Colors

#### **`vizlib.colors`**

Provides a list of 24 colors, sorted by hue. Each value is a table containing two values:
- `name` - The name of the color, in lowercase.
- `hex` - The RGB hex code for the color, including the `#` prefix.

#### **`vizlib.select_color()`**

Selects a random color from `vizlib.colors`.

**Returns**
- A hex color code, including the `#` prefix.

#### **`vizlib.random_color()`**

Generates a completely random color.

**Returns**
- A hex color code, including the `#` prefix.


## Drawing

#### **`vizlib.draw_circle(pos, radius, axis, options)`**

#### **`vizlib.draw_sphere(pos, radius, options)`**

#### **`vizlib.draw_line(pos1, pos2, options)`**

#### **`vizlib.draw_square(pos, radius, axis, options)`**

#### **`vizlib.draw_cube(pos, radius, options)`**

#### **`vizlib.draw_area(pos1, pos2, options)`**


## Utility

#### **`vizlib.erase_shape(shape)`**

Removes a shape from the world.

**Arguments**
- `shape` - The shape to be removed.