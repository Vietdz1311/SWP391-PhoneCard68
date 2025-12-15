<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="./components/header.jsp" />

<section class="py-16 bg-gradient-to-br from-slate-50 to-blue-50 min-h-screen">
  <div class="container mx-auto px-4">
    <div class="max-w-4xl mx-auto">
      
      <!-- Page Title -->
      <div class="text-center mb-10">
        <h1 class="text-4xl font-bold text-gray-900 mb-3">Thanh toán đơn hàng</h1>
        <p class="text-gray-600 text-lg">Hoàn tất thanh toán để nhận thẻ cào ngay lập tức</p>
      </div>

      <!-- Error Message -->
      <c:if test="${not empty error}">
        <div class="bg-red-50 border-l-4 border-red-500 p-4 mb-8 rounded-r-xl">
          <div class="flex items-center">
            <i class='bx bx-error-circle text-red-500 text-2xl mr-3'></i>
            <p class="text-red-700 font-medium">${error}</p>
          </div>
        </div>
      </c:if>

      <div class="grid lg:grid-cols-5 gap-8">
        
        <!-- Order Summary -->
        <div class="lg:col-span-2">
          <div class="bg-white rounded-2xl shadow-xl overflow-hidden sticky top-24">
            <div class="bg-gradient-to-r from-blue-600 to-indigo-600 px-6 py-4">
              <h2 class="text-xl font-bold text-white">Thông tin đơn hàng</h2>
            </div>
            
            <div class="p-6">
              <!-- Product Info -->
              <div class="flex items-center gap-4 pb-6 border-b border-gray-100">
                <img src="${product.provider.logoUrl != null ? product.provider.logoUrl : 'https://via.placeholder.com/80?text=' += product.provider.providerName}"
                     alt="${product.provider.providerName}"
                     class="w-20 h-20 object-contain rounded-xl bg-gray-50 p-2">
                <div>
                  <h3 class="font-bold text-gray-900 text-lg">${product.productName}</h3>
                  <p class="text-blue-600 font-medium">${product.provider.providerName}</p>
                </div>
              </div>
              
              <!-- Price Details -->
              <div class="py-6 space-y-3">
                <div class="flex justify-between items-center">
                  <span class="text-gray-600">Mệnh giá</span>
                  <span class="font-semibold text-green-600">
                    <fmt:formatNumber value="${product.faceValue}" type="currency" currencySymbol="₫"/>
                  </span>
                </div>
                <div class="flex justify-between items-center">
                  <span class="text-gray-600">Giá bán</span>
                  <span class="font-bold text-2xl text-gray-900">
                    <fmt:formatNumber value="${product.sellingPrice}" type="currency" currencySymbol="₫"/>
                  </span>
                </div>
              </div>
              
              <!-- Wallet Info -->
              <div class="pt-6 border-t border-gray-100">
                <div class="flex justify-between items-center mb-2">
                  <span class="text-gray-600">Số dư ví hiện tại</span>
                  <span class="font-bold text-xl ${sessionScope.user.walletBalance >= product.sellingPrice ? 'text-green-600' : 'text-orange-500'}">
                    <fmt:formatNumber value="${sessionScope.user.walletBalance}" type="number"/>₫
                  </span>
                </div>
                <c:if test="${sessionScope.user.walletBalance < product.sellingPrice}">
                  <p class="text-sm text-orange-600 flex items-center">
                    <i class='bx bx-info-circle mr-1'></i>
                    Cần nạp thêm: <fmt:formatNumber value="${product.sellingPrice - sessionScope.user.walletBalance}" type="number"/>₫
                  </p>
                </c:if>
              </div>
            </div>
          </div>
        </div>

        <!-- Payment Methods -->
        <div class="lg:col-span-3">
          <div class="bg-white rounded-2xl shadow-xl overflow-hidden">
            <div class="px-6 py-4 border-b border-gray-100">
              <h2 class="text-xl font-bold text-gray-900">Chọn phương thức thanh toán</h2>
            </div>
            
            <form action="${pageContext.request.contextPath}/purchase" method="post" class="p-6">
              <input type="hidden" name="productId" value="${product.productId}">
              
              <div class="space-y-4">
                
                <!-- Wallet Payment -->
                <label class="payment-option block cursor-pointer">
                  <input type="radio" name="paymentMethod" value="wallet" 
                         class="hidden peer" 
                         ${sessionScope.user.walletBalance >= product.sellingPrice ? 'checked' : 'disabled'}>
                  <div class="border-2 rounded-xl p-5 transition-all duration-300 
                              peer-checked:border-blue-500 peer-checked:bg-blue-50 
                              peer-disabled:opacity-50 peer-disabled:cursor-not-allowed
                              hover:border-blue-300">
                    <div class="flex items-center justify-between">
                      <div class="flex items-center gap-4">
                        <div class="w-14 h-14 bg-gradient-to-br from-green-400 to-emerald-600 rounded-xl flex items-center justify-center">
                          <i class='bx bx-wallet text-white text-2xl'></i>
                        </div>
                        <div>
                          <h3 class="font-bold text-gray-900">Thanh toán bằng Ví</h3>
                          <p class="text-sm text-gray-500">Số dư: <fmt:formatNumber value="${sessionScope.user.walletBalance}" type="number"/>₫</p>
                        </div>
                      </div>
                      <div class="w-6 h-6 rounded-full border-2 border-gray-300 peer-checked:border-blue-500 peer-checked:bg-blue-500 flex items-center justify-center">
                        <i class='bx bx-check text-white text-sm hidden peer-checked:block'></i>
                      </div>
                    </div>
                    <c:if test="${sessionScope.user.walletBalance < product.sellingPrice}">
                      <div class="mt-3 flex items-center justify-between bg-orange-50 rounded-lg p-3">
                        <span class="text-orange-700 text-sm font-medium">
                          <i class='bx bx-error-circle mr-1'></i>
                          Số dư không đủ
                        </span>
                        <a href="${pageContext.request.contextPath}/deposit?amount=${product.sellingPrice - sessionScope.user.walletBalance}&returnTo=/purchase?productId=${product.productId}" 
                           class="text-sm font-bold text-blue-600 hover:text-blue-700 hover:underline">
                          Nạp ngay →
                        </a>
                      </div>
                    </c:if>
                  </div>
                </label>

                <!-- VNPay Payment -->
                <label class="payment-option block cursor-pointer">
                  <input type="radio" name="paymentMethod" value="vnpay" class="hidden peer"
                         ${sessionScope.user.walletBalance < product.sellingPrice ? 'checked' : ''}>
                  <div class="border-2 rounded-xl p-5 transition-all duration-300 
                              peer-checked:border-blue-500 peer-checked:bg-blue-50 
                              hover:border-blue-300">
                    <div class="flex items-center justify-between">
                      <div class="flex items-center gap-4">
                        <div class="w-14 h-14 bg-gradient-to-br from-red-500 to-pink-600 rounded-xl flex items-center justify-center">
                          <i class='bx bx-credit-card text-white text-2xl'></i>
                        </div>
                        <div>
                          <h3 class="font-bold text-gray-900">Thanh toán VNPay</h3>
                          <p class="text-sm text-gray-500">ATM / Visa / MasterCard / QR Code</p>
                        </div>
                      </div>
                      <div class="w-6 h-6 rounded-full border-2 border-gray-300 peer-checked:border-blue-500 peer-checked:bg-blue-500 flex items-center justify-center">
                        <i class='bx bx-check text-white text-sm hidden peer-checked:block'></i>
                      </div>
                    </div>
                    <div class="mt-3 flex items-center gap-2">
                      <img src="https://sandbox.vnpayment.vn/paymentv2/images/icons/mics/32/napas.svg" alt="Napas" class="h-6">
                      <img src="https://sandbox.vnpayment.vn/paymentv2/images/icons/mics/32/visa.svg" alt="Visa" class="h-6">
                      <img src="https://sandbox.vnpayment.vn/paymentv2/images/icons/mics/32/mastercard.svg" alt="MasterCard" class="h-6">
                      <img src="https://sandbox.vnpayment.vn/paymentv2/images/icons/mics/32/jcb.svg" alt="JCB" class="h-6">
                    </div>
                  </div>
                </label>
              </div>

              <!-- Submit Button -->
              <div class="mt-8">
                <button type="submit" 
                        class="w-full bg-gradient-to-r from-blue-600 to-indigo-600 text-white font-bold text-lg py-4 rounded-xl 
                               hover:from-blue-700 hover:to-indigo-700 transition-all duration-300 shadow-lg hover:shadow-xl 
                               transform hover:-translate-y-0.5 flex items-center justify-center gap-2">
                  <i class='bx bx-lock-alt'></i>
                  Thanh toán <fmt:formatNumber value="${product.sellingPrice}" type="currency" currencySymbol="₫"/>
                </button>
              </div>

              <!-- Security Notice -->
              <div class="mt-6 flex items-start gap-3 text-sm text-gray-500">
                <i class='bx bx-shield-quarter text-green-500 text-xl flex-shrink-0'></i>
                <p>Giao dịch của bạn được bảo mật bằng công nghệ mã hóa SSL 256-bit. Thẻ sẽ được gửi ngay sau khi thanh toán thành công.</p>
              </div>
            </form>
          </div>

          <!-- Back Link -->
          <div class="mt-6 text-center">
            <a href="${pageContext.request.contextPath}/products?action=details&id=${product.productId}" 
               class="inline-flex items-center text-gray-600 hover:text-blue-600 font-medium transition">
              <i class='bx bx-chevron-left mr-1'></i> Quay lại chi tiết sản phẩm
            </a>
          </div>
        </div>
      </div>
    </div>
  </div>
</section>

<style>
.payment-option input:checked + div {
  border-color: #3b82f6;
  background-color: #eff6ff;
}
.payment-option input:checked + div .peer-checked\:block {
  display: block;
}
.payment-option input:checked + div > div:first-child > div:last-child {
  background-color: #3b82f6;
  border-color: #3b82f6;
}
.payment-option input:checked + div > div:first-child > div:last-child i {
  display: block;
}
</style>

<jsp:include page="./components/footer.jsp" />

