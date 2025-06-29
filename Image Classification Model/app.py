import tensorflow as tf
from tensorflow import keras
from tensorflow.keras.models import load_model
import streamlit as st
import numpy as np
import os

st.header('Image Classification Model')

# Load the model (make sure to fix path with r-string or double slashes)
model = load_model(r"C:\Users\ELCOT\Desktop\Image_Classification\Image_classify.keras")

# Classes
data_cat = ['apple','banana','beetroot','bell pepper','cabbage','capsicum','carrot',
 'cauliflower','chilli pepper','corn','cucumber','eggplant','garlic','ginger','grapes',
 'jalepeno','kiwi','lemon','lettuce','mango','onion','orange','paprika','pear','peas',
 'pineapple','pomegranate','potato','raddish','soy beans','spinach','sweetcorn',
 'sweetpotato','tomato','turnip','watermelon']

# Calorie info per 100g (approximate)
calorie_info = {
    'apple': 52, 'banana': 89, 'beetroot': 43, 'bell pepper': 20, 'cabbage': 25,
    'capsicum': 20, 'carrot': 41, 'cauliflower': 25, 'chilli pepper': 40, 'corn': 96,
    'cucumber': 16, 'eggplant': 25, 'garlic': 149, 'ginger': 80, 'grapes': 69,
    'jalepeno': 29, 'kiwi': 61, 'lemon': 29, 'lettuce': 15, 'mango': 60,
    'onion': 40, 'orange': 47, 'paprika': 282, 'pear': 57, 'peas': 81,
    'pineapple': 50, 'pomegranate': 83, 'potato': 77, 'raddish': 16, 'soy beans': 446,
    'spinach': 23, 'sweetcorn': 86, 'sweetpotato': 86, 'tomato': 18, 'turnip': 28,
    'watermelon': 30
}

# Set image size
img_height = 180
img_width = 180

# Folder where input images are stored
input_folder = "Input_Images"

# Get image file name (from user input)
image_file = st.text_input('Enter image file name (e.g., apple.jpg)', 'banana.jpg')

# Full path
image_path = os.path.join(input_folder, image_file)

# Try loading the image
try:
    image_load = tf.keras.utils.load_img(image_path, target_size=(img_height, img_width))
    img_arr = tf.keras.utils.img_to_array(image_load)
    img_bat = tf.expand_dims(img_arr, 0)

    # Predict
    predict = model.predict(img_bat)
    score = tf.nn.softmax(predict)

    # Result
    predicted_label = data_cat[np.argmax(score)]
    confidence = np.max(score) * 100
    calories = calorie_info.get(predicted_label, "Not available")

    # Output
    st.image(image_path, width=200)
    st.write(f'Predicted: **{predicted_label.capitalize()}**')
    st.write(f'Confidence: **{confidence:.2f}%**')
    st.write(f'Calories per 100g: **{calories} kcal**')

except Exception as e:
    st.error(f"Error loading image: {e}")
