import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["prompt"]

  connect() {
    if ('webkitSpeechRecognition' in window) {
      this.recognition = new webkitSpeechRecognition();
      this.recognition.continuous = true;
      this.recognition.interimResults = false;
      this.recognition.lang = 'en-AU';

      this.recognition.onresult = this.onResult.bind(this);
      this.recognition.onerror = this.onError.bind(this);
      this.recognition.onend = this.onEnd.bind(this);
    } else {
      console.log('Speech recognition not supported in this browser.');
    }
  }

  startCapture() {
    if (this.recognition) {
      this.recognition.start();
      console.log('Speech recognition started');
    }
  }

  stopCapture() {
    if (this.recognition) {
      this.recognition.stop();
      console.log('Speech recognition stopped');
    }
  }

  onResult(event) {
    let finalTranscript = '';
    for (let i = event.resultIndex; i < event.results.length; ++i) {
      if (event.results[i].isFinal) {
        finalTranscript += event.results[i][0].transcript;
      }
    }
    console.log('Final result: ', finalTranscript);
    this.appendText(finalTranscript);
  }

  appendText(text) {
    this.promptTarget.value += text + ' ';
  }

  onError(event) {
    console.error('Error occurred in recognition: ', event.error);
  }

  onEnd() {
    console.log('Speech recognition ended');
  }
}
