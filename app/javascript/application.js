document.addEventListener('DOMContentLoaded', () => {
    function generateRandomPhrase(length) {
      const chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
      let phrase = "";
      for (let i = 0; i < length; i++) {
        phrase += chars.charAt(Math.floor(Math.random() * chars.length));
      }
      return phrase;
    }
  
    function createRandomTextElement(phrase) {
      const backgroundTextElement = document.createElement('div');
      backgroundTextElement.classList.add('background-text');
      document.body.appendChild(backgroundTextElement);
  
      const maxWidth = window.innerWidth - 200;
      const maxHeight = window.innerHeight - 50;
  
      const randomX = Math.random() * maxWidth;
      const randomY = Math.random() * maxHeight;
  
      backgroundTextElement.style.left = `${randomX}px`;
      backgroundTextElement.style.top = `${randomY}px`;
  
      let currentLetterIndex = 0;
  
      function type() {
        if (currentLetterIndex < phrase.length) {
          backgroundTextElement.textContent += phrase.charAt(currentLetterIndex);
          currentLetterIndex++;
          setTimeout(type, 100);
        } else {
          setTimeout(erase, 2000);
        }
      }
  
      function erase() {
        if (currentLetterIndex > 0) {
          backgroundTextElement.textContent = backgroundTextElement.textContent.slice(0, -1);
          currentLetterIndex--;
          setTimeout(erase, 50);
        } else {
          setTimeout(type, 1000);
        }
      }
  
      type();
    }
  
    for (let i = 0; i < 10; i++) { // 5つの要素を生成する例
      createRandomTextElement(generateRandomPhrase(10)); // 10文字のランダムな文字列を生成
    }
  });
  