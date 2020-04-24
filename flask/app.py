#!/usr/bin/env python3
from flask import Flask, render_template, url_for
from flask_wtf import FlaskForm, form
from wtforms import StringField, SubmitField, TextField, TextAreaField
from wtforms.validators import DataRequired, Length, ValidationError

app = Flask(__name__)
app.secret_key = 'dupa'


class MessageForm(FlaskForm):
    message = TextAreaField('Message', validators=[DataRequired(), Length(min=2)])
    submit = SubmitField('wyslij')


def generate_json(message):
    with open('request-template.json', 'r') as file:
        content = file.read()
        add_message = content.replace("PLACE_HERE", message)
        with open("request.json", "w") as new_file:
            new_file.write(add_message)


@app.route('/')
@app.route('/form', methods=['GET', 'POST'])
def message_form():
    form = MessageForm()
    return render_template('message_form.html', form=form)


@app.route('/attention', methods=['POST'])
def attention():
    form = MessageForm()
    if form.validate_on_submit():
        message = form.message.data
        generate_json(message)
        return f"Formularz OK. Tresc: {message}"
    return render_template('invalid.html')


if __name__ == '__main__':
    app.run(debug=True, host="0.0.0.0")
