document.addEventListener('turbolinks:load', function() {
    console.log('JavaScript loaded');
    const publishButton = document.getElementById('publish-article-button');
    if (publishButton) {
      console.log('Publish button found');
      publishButton.addEventListener('click', function(event) {
        console.log('Button clicked');
        event.preventDefault(); // デフォルトの動作を防ぐ
  
        // フォームデータを収集
        const title = document.getElementById('article-title').value;
        const description = document.getElementById('article-description').value;
        const body = document.getElementById('article-body').value;
        const tagList = document.getElementById('article-tags').value.split(',');
  
        const articleData = {
          article: {
            title: title,
            description: description,
            body: body,
            tagList: tagList
          }
        };
  
        console.log('Sending API request', articleData);
  
        // APIリクエストを送信
        fetch('/api/articles', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify(articleData)
        })
        .then(response => {
          if (!response.ok) {
            throw new Error('Network response was not ok');
          }
          return response.json();
        })
        .then(data => {
          console.log('Success:', data);
          // 成功時の処理: ホームページにリダイレクト
          window.location.href = '/';
        })
        .catch((error) => {
          console.error('Error:', error);
          alert('An error occurred while creating the article.');
        });
      });
    } else {
      console.log('Publish button not found');
    }
  });