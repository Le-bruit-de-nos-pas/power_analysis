import base64

def image_to_base64(image_path):
    with open(image_path, "rb") as image_file:
        encoded_string = base64.b64encode(image_file.read()).decode("utf-8")
    return encoded_string

# Example usage:
image_path = "Figure_3.png"
encoded_image = image_to_base64(image_path)
print(encoded_image)

# Add to html
# replace   INSERT_BASE64_ENCODED_STRING_HERE  with the string encoded_image
# <img src="data:image/png;base64,INSERT_BASE64_ENCODED_STRING_HERE" alt="Image 1">