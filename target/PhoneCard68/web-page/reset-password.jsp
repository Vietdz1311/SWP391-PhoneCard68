<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Đặt lại mật khẩu - PhoneCard68</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: {
                            50: '#eff6ff',
                            500: '#3b82f6',
                            600: '#2563eb',
                            700: '#1d4ed8',
                        }
                    }
                }
            }
        }
    </script>
    <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet" />
</head>
<body class="bg-gradient-to-br from-blue-50 to-indigo-100 min-h-screen flex items-center justify-center p-4">

<div class="bg-white rounded-2xl shadow-2xl p-10 w-full max-w-md">
    <div class="text-center mb-8">
        <div class="w-16 h-16 bg-gradient-to-r from-green-500 to-emerald-500 rounded-full mx-auto flex items-center justify-center mb-4">
            <i class='bx bx-key text-white text-3xl'></i>
        </div>
        <h2 class="text-3xl font-bold text-gray-900">Đặt mật khẩu mới</h2>
        <p class="text-gray-500 mt-2">Nhập mã OTP đã gửi về email</p>
    </div>
    
    <c:if test="${not empty error}">
        <div class="bg-red-50 border border-red-200 rounded-xl p-4 mb-6 flex items-start gap-3">
            <i class='bx bx-error-circle text-red-500 text-xl mt-0.5'></i>
            <p class="text-red-700">${error}</p>
        </div>
    </c:if>
    
    <form action="${pageContext.request.contextPath}/auth" method="post" id="resetForm">
        <input type="hidden" name="action" value="reset-password">
        
        <div class="mb-5">
            <label class="block text-gray-700 font-medium mb-2">
                <i class='bx bx-lock mr-1'></i> Mã OTP
            </label>
            <input type="text" name="token" required minlength="4" maxlength="10"
                   placeholder="Nhập mã OTP 6 số"
                   class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition font-mono text-lg tracking-widest">
        </div>
        
        <div class="mb-5">
            <label class="block text-gray-700 font-medium mb-2">
                <i class='bx bx-lock-alt mr-1'></i> Mật khẩu mới
            </label>
            <div class="relative">
                <input type="password" name="password" id="password" required minlength="6"
                       placeholder="Ít nhất 6 ký tự"
                       class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition pr-12">
                <button type="button" onclick="togglePassword('password')" 
                        class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600">
                    <i class='bx bx-show text-xl' id="password-icon"></i>
                </button>
            </div>
        </div>
        
        <div class="mb-6">
            <label class="block text-gray-700 font-medium mb-2">
                <i class='bx bx-lock mr-1'></i> Xác nhận mật khẩu
            </label>
            <div class="relative">
                <input type="password" name="confirmPassword" id="confirmPassword" required
                       placeholder="Nhập lại mật khẩu"
                       class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition pr-12">
                <button type="button" onclick="togglePassword('confirmPassword')" 
                        class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600">
                    <i class='bx bx-show text-xl' id="confirmPassword-icon"></i>
                </button>
            </div>
            <p id="matchError" class="text-red-500 text-sm mt-1 hidden">Mật khẩu không khớp</p>
        </div>
        
        <!-- Password Strength Indicator -->
        <div class="mb-6">
            <div class="flex gap-1">
                <div id="strength-1" class="h-1 flex-1 bg-gray-200 rounded transition-colors"></div>
                <div id="strength-2" class="h-1 flex-1 bg-gray-200 rounded transition-colors"></div>
                <div id="strength-3" class="h-1 flex-1 bg-gray-200 rounded transition-colors"></div>
                <div id="strength-4" class="h-1 flex-1 bg-gray-200 rounded transition-colors"></div>
            </div>
            <p id="strength-text" class="text-xs text-gray-500 mt-1"></p>
        </div>
        
        <button type="submit" id="submitBtn"
                class="w-full bg-gradient-to-r from-green-600 to-emerald-600 text-white font-bold py-3 rounded-xl hover:from-green-700 hover:to-emerald-700 transition duration-300 shadow-lg flex items-center justify-center gap-2">
            <i class='bx bx-check'></i>
            Đặt lại mật khẩu
        </button>
    </form>
    
    <div class="mt-8 text-center">
        <a href="${pageContext.request.contextPath}/auth" class="text-blue-600 font-medium hover:underline flex items-center justify-center gap-1">
            <i class='bx bx-arrow-back'></i>
            Quay lại đăng nhập
        </a>
    </div>
</div>

<script>
function togglePassword(inputId) {
    const input = document.getElementById(inputId);
    const icon = document.getElementById(inputId + '-icon');
    
    if (input.type === 'password') {
        input.type = 'text';
        icon.classList.remove('bx-show');
        icon.classList.add('bx-hide');
    } else {
        input.type = 'password';
        icon.classList.remove('bx-hide');
        icon.classList.add('bx-show');
    }
}

// Password strength checker
document.getElementById('password')?.addEventListener('input', function(e) {
    const password = e.target.value;
    let strength = 0;
    
    if (password.length >= 6) strength++;
    if (password.length >= 8) strength++;
    if (/[A-Z]/.test(password) && /[a-z]/.test(password)) strength++;
    if (/[0-9]/.test(password) || /[^A-Za-z0-9]/.test(password)) strength++;
    
    const colors = ['', 'bg-red-400', 'bg-yellow-400', 'bg-blue-400', 'bg-green-400'];
    const texts = ['', 'Yếu', 'Trung bình', 'Khá', 'Mạnh'];
    
    for (let i = 1; i <= 4; i++) {
        const el = document.getElementById('strength-' + i);
        el.className = 'h-1 flex-1 rounded transition-colors ' + (i <= strength ? colors[strength] : 'bg-gray-200');
    }
    
    document.getElementById('strength-text').textContent = password.length > 0 ? 'Độ mạnh: ' + texts[strength] : '';
});

// Password match checker
document.getElementById('confirmPassword')?.addEventListener('input', function(e) {
    const password = document.getElementById('password').value;
    const confirm = e.target.value;
    const errorEl = document.getElementById('matchError');
    
    if (confirm.length > 0 && password !== confirm) {
        errorEl.classList.remove('hidden');
    } else {
        errorEl.classList.add('hidden');
    }
});

// Form validation
document.getElementById('resetForm')?.addEventListener('submit', function(e) {
    const password = document.getElementById('password').value;
    const confirm = document.getElementById('confirmPassword').value;
    
    if (password !== confirm) {
        e.preventDefault();
        document.getElementById('matchError').classList.remove('hidden');
        document.getElementById('confirmPassword').focus();
    }
});
</script>

</body>
</html>

