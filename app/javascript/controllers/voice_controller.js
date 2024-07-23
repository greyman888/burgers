import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["chunk", "notice"]

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

  // Capture voice to text

  startCapture() {
    if (this.recognition) {
      this.recognition.start();
      console.log('Speech recognition started');
      this.noticeTarget.classList.toggle("visually-hidden")
    }
  }

  stopCapture() {
    if (this.recognition) {
      this.recognition.stop();
      console.log('Speech recognition stopped');
      this.noticeTarget.classList.toggle("visually-hidden")
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
    this.chunkTarget.value += text + ' ';
  }

  onError(event) {
    console.error('Error occurred in recognition: ', event.error);
  }

  onEnd() {
    console.log('Speech recognition ended');
  }

}
