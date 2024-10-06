document.addEventListener('DOMContentLoaded', function() {
    var logoutButton = document.getElementById('logoutButton');
    if (logoutButton) {
      logoutButton.addEventListener('click', function() {
        const authToken = localStorage.getItem('authToken');
        if (!authToken) {
          alert('認証トークンが見つかりません。再度ログインしてください。');
          return;
        }
  
        fetch('/logout', {
          method: 'DELETE',
          headers: {
            'Authorization': `Bearer ${authToken}`,
            'Content-Type': 'application/json',
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content') // CSRFトークンを追加
          }
        })
        .then(response => {
          if (response.ok) {
            localStorage.removeItem('authToken'); // トークンを削除
            window.location.href = '/login'; // ログインページにリダイレクト
          } else {
            alert('ログアウトに失敗しました。');
          }
        })
        .catch(error => console.error('Error:', error));
      });
    } else {
      console.log('Logout button not found');
    }
  });