from flask import Flask, request, render_template, send_file
from werkzeug.utils import secure_filename
import os
app = Flask(__name__, static_url_path='/', static_folder='static')

@app.route('/')
def hello_world():
   return render_template('index.html')

@app.route('/Upload', methods=['POST'])
def upload_file():
    if request.method == 'POST':
        f = request.files['RemoteFile']
        path = './uploaded/'
        if os.path.exists(path)==False:
            os.makedirs(path)
        f.save(os.path.join(path,secure_filename(f.filename)))
        response={"status": "success", "filename": f.filename}
        return response
        
@app.route('/Get', methods=['GET'])
def get():
    filename = request.args.get('filename', '')
    path = os.path.join('./uploaded/',filename)
    if os.path.exists(path):
        return send_file(path,as_attachment=True, attachment_filename=filename)


if __name__ == '__main__':
   app.run()