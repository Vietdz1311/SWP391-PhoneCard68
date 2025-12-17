<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="./components/header.jsp" />

<section class="py-20 bg-gray-50 min-h-screen">
  <div class="container mx-auto px-4">
    <div class="max-w-4xl mx-auto bg-white rounded-2xl shadow-2xl overflow-hidden">
      <div class="bg-gradient-to-r from-blue-600 to-indigo-600 py-8 px-10 text-white">
        <h1 class="text-4xl font-bold">Thông tin tài khoản</h1>
        <p class="text-xl mt-2">Quản lý thông tin cá nhân và bảo mật tài khoản</p>
      </div>

      <div class="p-10">
        <c:if test="${not empty success}">
          <div class="bg-green-100 border border-green-400 text-green-700 px-6 py-4 rounded-xl mb-8 flex items-center">
            <i class='bx bx-check-circle text-2xl mr-3'></i> ${success}
          </div>
        </c:if>
        <c:if test="${not empty error}">
          <div class="bg-red-100 border border-red-400 text-red-700 px-6 py-4 rounded-xl mb-8 flex items-center">
            <i class='bx bx-error-circle text-2xl mr-3'></i> ${error}
          </div>
        </c:if>

        <div class="space-y-8 text-lg">
          <div class="grid md:grid-cols-2 gap-8">
            <div>
              <p><strong>Tên đăng nhập:</strong> ${user.username}</p>
              <p><strong>Email:</strong> ${user.email}</p>
              <p><strong>Số điện thoại:</strong> ${user.phone}</p>
            </div>
            <div>
              <p class="mb-3"><strong>Số dư ví:</strong> <span class="text-green-600 font-bold text-2xl"><fmt:formatNumber value="${user.walletBalance}" type="number"/>₫</span></p>
              <a href="${pageContext.request.contextPath}/deposit" 
                 class="inline-flex items-center gap-2 bg-gradient-to-r from-green-500 to-emerald-600 text-white px-4 py-2 rounded-xl hover:from-green-600 hover:to-emerald-700 transition font-medium shadow-md text-sm">
                <i class='bx bx-plus'></i> Nạp tiền
              </a>
              <p class="mt-3"><strong>Vai trò:</strong> <span class="px-3 py-1 rounded-full text-sm font-medium ${user.role == 'Admin' ? 'bg-purple-100 text-purple-800' : sessionScope.user.role == 'Staff' ? 'bg-blue-100 text-blue-800' : 'bg-gray-100 text-gray-800'}">${sessionScope.user.role}</span></p>
            </div>
          </div>

          <div class="flex flex-col sm:flex-row gap-6 mt-10">
            <button onclick="openModal('updateProfileModal')"
                    class="flex-1 bg-gradient-to-r from-blue-600 to-indigo-600 text-white font-bold py-4 rounded-xl hover:from-blue-700 hover:to-indigo-700 transition shadow-lg transform hover:scale-105">
              <i class='bx bx-edit-alt mr-3'></i> Cập nhật thông tin
            </button>
            <button onclick="openModal('changePasswordModal')"
                    class="flex-1 bg-gradient-to-r from-red-600 to-pink-600 text-white font-bold py-4 rounded-xl hover:from-red-700 hover:to-pink-700 transition shadow-lg transform hover:scale-105">
              <i class='bx bx-lock-alt mr-3'></i> Đổi mật khẩu
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</section>

<div id="updateProfileModal" class="fixed inset-0 bg-black bg-opacity-60 hidden flex items-center justify-center z-50 px-4">
  <div class="bg-white rounded-2xl shadow-2xl max-w-lg w-full p-8 relative animate-scale-in">
    <button onclick="closeModal('updateProfileModal')" class="absolute top-4 right-4 text-gray-500 hover:text-gray-700 text-3xl">
      <i class='bx bx-x'></i>
    </button>
    <h2 class="text-3xl font-bold mb-6 text-center">Cập nhật thông tin</h2>
    <form action="profile" method="post">
      <input type="hidden" name="action" value="updateProfile">
      <div class="space-y-5">
        <div>
          <label class="block text-gray-700 font-medium mb-2">Tên đăng nhập</label>
          <input type="text" name="username" value="${user.username}" required
                 class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500">
        </div>
        <div>
          <label class="block text-gray-700 font-medium mb-2">Email</label>
          <input type="email" name="email" value="${user.email}" required
                 class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500">
        </div>
        <div>
          <label class="block text-gray-700 font-medium mb-2">Số điện thoại</label>
          <input type="text" name="phone" value="${user.phone}" required
                 class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500">
        </div>
        <div class="flex gap-4 mt-8">
          <button type="submit"
                  class="flex-1 bg-gradient-to-r from-blue-600 to-indigo-600 text-white font-bold py-3 rounded-xl hover:from-blue-700 hover:to-indigo-700 transition shadow-lg">
            Lưu thay đổi
          </button>
          <button type="button" onclick="closeModal('updateProfileModal')"
                  class="flex-1 bg-gray-200 text-gray-800 font-bold py-3 rounded-xl hover:bg-gray-300 transition">
            Hủy
          </button>
        </div>
      </div>
    </form>
  </div>
</div>

<div id="changePasswordModal" class="fixed inset-0 bg-black bg-opacity-60 hidden flex items-center justify-center z-50 px-4">
  <div class="bg-white rounded-2xl shadow-2xl max-w-lg w-full p-8 relative animate-scale-in">
    <button onclick="closeModal('changePasswordModal')" class="absolute top-4 right-4 text-gray-500 hover:text-gray-700 text-3xl">
      <i class='bx bx-x'></i>
    </button>
    <h2 class="text-3xl font-bold mb-6 text-center">Đổi mật khẩu</h2>
    <form action="profile" method="post">
      <input type="hidden" name="action" value="changePassword">
      <div class="space-y-5">
        <div>
          <label class="block text-gray-700 font-medium mb-2">Mật khẩu cũ</label>
          <input type="password" name="oldPassword" required
                 class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500">
        </div>
        <div>
          <label class="block text-gray-700 font-medium mb-2">Mật khẩu mới</label>
          <input type="password" name="newPassword" required
                 class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500">
        </div>
        <div>
          <label class="block text-gray-700 font-medium mb-2">Xác nhận mật khẩu mới</label>
          <input type="password" name="confirmPassword" required
                 class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500">
        </div>
        <div class="flex gap-4 mt-8">
          <button type="submit"
                  class="flex-1 bg-gradient-to-r from-red-600 to-pink-600 text-white font-bold py-3 rounded-xl hover:from-red-700 hover:to-pink-700 transition shadow-lg">
            Đổi mật khẩu
          </button>
          <button type="button" onclick="closeModal('changePasswordModal')"
                  class="flex-1 bg-gray-200 text-gray-800 font-bold py-3 rounded-xl hover:bg-gray-300 transition">
            Hủy
          </button>
        </div>
      </div>
    </form>
  </div>
</div>

<script>
  function openModal(modalId) {
    document.getElementById(modalId).classList.remove('hidden');
    document.body.style.overflow = 'hidden'; /
  }

  function closeModal(modalId) {
    document.getElementById(modalId).classList.add('hidden');
    document.body.style.overflow = 'auto';
  }

  window.onclick = function(event) {
    if (event.target.classList.contains('bg-black')) {
      event.target.classList.add('hidden');
      document.body.style.overflow = 'auto';
    }
  }
</script>

<style>
  @keyframes scaleIn {
    from { opacity: 0; transform: scale(0.95); }
    to { opacity: 1; transform: scale(1); }
  }
  .animate-scale-in { animation: scaleIn 0.3s ease-out; }
</style>

<jsp:include page="./components/footer.jsp" />