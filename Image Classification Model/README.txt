Image Classification & Calorie Estimator

This project performs image classification on various fruits and vegetables using a Convolutional Neural Network (CNN) built in TensorFlow/Keras. It also estimates calories per 100g for the predicted item.



Project Structure



+-- Image_Class_Modal.ipynb    # Jupyter notebook to train the image classification model
+-- app.py                     # Streamlit app to run the image classifier and display calories
+-- Input_Images/              # Folder containing test images (add your own images here)
+-- Image_classify.keras       # Saved Keras model (generated from notebook)




Model Overview

* Input shape: `180x180` RGB images
* Model: CNN built using TensorFlow/Keras
* Classes: 36 fruits and vegetables
* Output: Class label + confidence + calories per 100g



Dataset

The dataset consists of images for the following 36 categories:

`apple`, `banana`, `beetroot`, `bell pepper`, `cabbage`, `capsicum`, `carrot`, `cauliflower`, `chilli pepper`, `corn`, `cucumber`, `eggplant`, `garlic`, `ginger`, `grapes`, `jalepeno`, `kiwi`, `lemon`, `lettuce`, `mango`, `onion`, `orange`, `paprika`, `pear`, `peas`, `pineapple`, `pomegranate`, `potato`, `raddish`, `soy beans`, `spinach`, `sweetcorn`, `sweetpotato`, `tomato`, `turnip`, `watermelon`

Each class has a corresponding calorie value (approx. per 100g) included in the `app.py`.



Requirements

Install dependencies with:


pip install tensorflow streamlit numpy pandas matplotlib seaborn




How to Use

Step 1: Train the Model

Open and run all cells in:


Image_Class_Modal.ipynb


This will:

* Load and preprocess your dataset
* Train a CNN model
* Save it as `Image_classify.keras`

>  You can change the dataset path and model parameters inside the notebook.



Step 2: Run the Streamlit App

Make sure the trained model (`Image_classify.keras`) is saved in the same folder as `app.py`.

Create a folder called `Input_Images/` and place your test image (e.g., `apple.jpg`) inside it.

Then run:


streamlit run app.py


In the UI:

* Enter the name of your image (e.g., `banana.jpg`)
* The app will display:

  * The image
  * Predicted label
  * Confidence %
  * Estimated calories per 100g



Example

![example](https://user-images.githubusercontent.com/example_image.png)


Future Improvements

* Use a public dataset and link it here
* Deploy the Streamlit app using Streamlit Cloud or HuggingFace Spaces
* Add upload button instead of manual filename input
* Use more advanced models (ResNet, EfficientNet)



Author

* Nowfal
* GitHub: https://github.com/Nowfal7861/My_Projects



License

This project is licensed under the MIT License.
