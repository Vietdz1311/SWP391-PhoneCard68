<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<footer class="bg-gradient-to-b from-gray-900 to-black text-white mt-auto">
  <!-- Main Footer Content -->
  <div class="container mx-auto px-4 py-16">
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-12">
      
      <div class="space-y-6">
        <a href="home" class="inline-block">
          <h3 class="text-4xl font-bold bg-gradient-to-r from-blue-400 to-indigo-500 bg-clip-text text-transparent">PhoneCard</h3>
        </a>
        <p class="text-gray-300 leading-relaxed max-w-xs">
          Hệ thống mua thẻ điện thoại giá rẻ nhất Việt Nam. Chiết khấu cao, giao thẻ tức thì 24/7, hỗ trợ nạp ví nhanh chóng và an toàn tuyệt đối.
        </p>
        <div class="flex space-x-4">
          <a href="#" class="w-12 h-12 bg-gray-800 rounded-full flex items-center justify-center hover:bg-blue-600 transition duration-300">
            <i class='bx bxl-facebook text-2xl'></i>
          </a>
          <a href="#" class="w-12 h-12 bg-gray-800 rounded-full flex items-center justify-center hover:bg-pink-600 transition duration-300">
            <i class='bx bxl-instagram text-2xl'></i>
          </a>
          <a href="#" class="w-12 h-12 bg-gray-800 rounded-full flex items-center justify-center hover:bg-blue-400 transition duration-300">
            <i class='bx bxl-telegram text-2xl'></i>
          </a>
          <a href="#" class="w-12 h-12 bg-gray-800 rounded-full flex items-center justify-center hover:bg-red-600 transition duration-300">
            <i class='bx bxl-youtube text-2xl'></i>
          </a>
        </div>
      </div>
      
      <!-- Column 2: Quick Links -->
      <div class="space-y-6">
        <h4 class="text-2xl font-bold text-blue-400">Liên kết nhanh</h4>
        <ul class="space-y-4">
          <li><a href="home" class="text-gray-300 hover:text-white transition duration-200 flex items-center"><i class='bx bx-chevron-right mr-2'></i>Trang chủ</a></li>
          <li><a href="products" class="text-gray-300 hover:text-white transition duration-200 flex items-center"><i class='bx bx-chevron-right mr-2'></i>Mua thẻ cào</a></li>
          <li><a href="blog" class="text-gray-300 hover:text-white transition duration-200 flex items-center"><i class='bx bx-chevron-right mr-2'></i>Tin tức & Khuyến mãi</a></li>
          <li><a href="history" class="text-gray-300 hover:text-white transition duration-200 flex items-center"><i class='bx bx-chevron-right mr-2'></i>Lịch sử giao dịch</a></li>
          <li><a href="profile" class="text-gray-300 hover:text-white transition duration-200 flex items-center"><i class='bx bx-chevron-right mr-2'></i>Thông tin tài khoản</a></li>
        </ul>
      </div>
      
      <!-- Column 3: Support & Policy -->
      <div class="space-y-6">
        <h4 class="text-2xl font-bold text-blue-400">Hỗ trợ</h4>
        <ul class="space-y-4">
          <li><a href="#" class="text-gray-300 hover:text-white transition duration-200 flex items-center"><i class='bx bx-chevron-right mr-2'></i>Hướng dẫn mua thẻ</a></li>
          <li><a href="#" class="text-gray-300 hover:text-white transition duration-200 flex items-center"><i class='bx bx-chevron-right mr-2'></i>Điều khoản dịch vụ</a></li>
          <li><a href="#" class="text-gray-300 hover:text-white transition duration-200 flex items-center"><i class='bx bx-chevron-right mr-2'></i>Chính sách bảo mật</a></li>
          <li><a href="#" class="text-gray-300 hover:text-white transition duration-200 flex items-center"><i class='bx bx-chevron-right mr-2'></i>Chính sách hoàn tiền</a></li>
          <li><a href="#" class="text-gray-300 hover:text-white transition duration-200 flex items-center"><i class='bx bx-chevron-right mr-2'></i>Liên hệ hỗ trợ</a></li>
        </ul>
      </div>
      
      <!-- Column 4: Contact Info -->
      <div class="space-y-6">
        <h4 class="text-2xl font-bold text-blue-400">Liên hệ</h4>
        <div class="space-y-4 text-gray-300">
          <p class="flex items-center"><i class='bx bx-map text-xl mr-3 text-blue-400'></i>TP. Hồ Chí Minh, Việt Nam</p>
          <p class="flex items-center"><i class='bx bx-phone text-xl mr-3 text-blue-400'></i>Hotline: 1900 1234</p>
          <p class="flex items-center"><i class='bx bx-envelope text-xl mr-3 text-blue-400'></i>support@phonecard.vn</p>
          <p class="flex items-center"><i class='bx bx-time text-xl mr-3 text-blue-400'></i>Hỗ trợ 24/7</p>
        </div>
        
        <!-- Newsletter (optional) -->
        <div class="mt-8">
          <p class="mb-4 font-medium">Đăng ký nhận ưu đãi</p>
          <form class="flex">
            <input type="email" placeholder="Email của bạn" class="px-4 py-3 rounded-l-xl bg-gray-800 text-white focus:outline-none focus:ring-2 focus:ring-blue-500 w-full">
            <button type="submit" class="bg-gradient-to-r from-blue-500 to-indigo-600 px-6 py-3 rounded-r-xl font-medium hover:from-blue-600 hover:to-indigo-700 transition">
              <i class='bx bx-send'></i>
            </button>
          </form>
        </div>
      </div>
      
    </div>
  </div>
  
  <!-- Bottom Bar -->
  <div class="border-t border-gray-800 py-6">
    <div class="container mx-auto px-4 text-center text-gray-400">
      <p>&copy; <script>document.write(new Date().getFullYear())</script> PhoneCard.vn - All rights reserved.</p>
      <p class="text-sm mt-2">Thiết kế & phát triển với ❤️ bởi đội ngũ PhoneCard</p>
    </div>
  </div>
</footer>

<style>
  html, body {
    height: 100%;
  }
  body {
    display: flex;
    flex-direction: column;
  }
  main {
    flex: 1;
  }
</style>