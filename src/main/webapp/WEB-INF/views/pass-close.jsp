<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head><meta charset="utf-8"><title>처리 중...</title></head>
<body>
    <script>
        (function () {
          var url = '${redirectUrl}';
          if (window.opener && !window.opener.closed) {
            try { window.opener.location.href = url; } catch (e) {}
          }
          window.close();
        })();
        </script>
</body>
</html>
