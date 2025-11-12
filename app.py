from flask import Flask, render_template, request
from textblob import TextBlob

app = Flask(__name__)

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/analyze', methods=['POST'])
def analyze():
    text = request.form.get('text', '')
    blob = TextBlob(text)
    polarity = blob.sentiment.polarity

    if polarity > 0:
        sentiment = 'Positive 😊'
    elif polarity < 0:
        sentiment = 'Negative 😞'
    else:
        sentiment = 'Neutral 😐'

    return render_template('index.html', text=text, sentiment=sentiment)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
