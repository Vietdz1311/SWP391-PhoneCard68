package com.phonecard.util;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.Properties;

public class EmailUtil {
    
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final int SMTP_PORT = 587;
    private static final String EMAIL_FROM = "tungnshe171062@fpt.edu.vn";
    private static final String EMAIL_PASSWORD = "qcxo yaae fxvd rpwi";
    
    private static Properties getMailProperties() {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", String.valueOf(SMTP_PORT));
        props.put("mail.smtp.ssl.trust", SMTP_HOST);
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");
        return props;
    }
    
    public static boolean sendPasswordResetEmail(String toEmail, String resetToken, String baseUrl) {
        try {
            Session session = Session.getInstance(getMailProperties(), new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(EMAIL_FROM, EMAIL_PASSWORD);
                }
            });

            String htmlContent = """
                <!DOCTYPE html>
                <html>
                <head>
                    <meta charset="UTF-8">
                    <style>
                        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f7fa; margin: 0; padding: 0; }
                        .container { max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 20px rgba(0,0,0,0.1); }
                        .header { background: linear-gradient(135deg, #3b82f6, #6366f1); padding: 40px 30px; text-align: center; }
                        .header h1 { color: #ffffff; margin: 0; font-size: 28px; }
                        .header p { color: rgba(255,255,255,0.9); margin-top: 10px; }
                        .content { padding: 40px 30px; }
                        .content p { color: #4b5563; line-height: 1.6; margin-bottom: 20px; }
                        .btn { display: inline-block; background: linear-gradient(135deg, #3b82f6, #6366f1); color: #ffffff !important; text-decoration: none; padding: 14px 40px; border-radius: 8px; font-weight: bold; margin: 20px 0; }
                        .btn:hover { opacity: 0.9; }
                        .warning { background-color: #fef3c7; border-left: 4px solid #f59e0b; padding: 15px; border-radius: 6px; margin-top: 20px; }
                        .warning p { color: #92400e; margin: 0; font-size: 14px; }
                        .footer { background-color: #f9fafb; padding: 20px 30px; text-align: center; border-top: 1px solid #e5e7eb; }
                        .footer p { color: #9ca3af; font-size: 13px; margin: 5px 0; }
                    </style>
                </head>
                <body>
                    <div class="container">
                        <div class="header">
                            <h1>🔐 PhoneCard68</h1>
                            <p>Yêu cầu đặt lại mật khẩu</p>
                        </div>
                        <div class="content">
                            <p>Xin chào,</p>
                            <p>Chúng tôi nhận được yêu cầu đặt lại mật khẩu cho tài khoản của bạn.</p>
                            <p>Nhập mã OTP dưới đây vào màn hình đổi mật khẩu:</p>
                            
                            <div style="text-align: center; margin: 24px 0;">
                                <div style="display: inline-block; padding: 14px 32px; font-size: 26px; font-weight: 700; letter-spacing: 4px; color: #111827; background: #eef2ff; border: 1px dashed #6366f1; border-radius: 12px;">
                                    %s
                                </div>
                            </div>
                            
                            <div class="warning">
                                <p>⚠️ <strong>Lưu ý:</strong> Mã OTP có hiệu lực trong <strong>15 phút</strong>. Không chia sẻ mã này cho bất kỳ ai.</p>
                            </div>
                            
                            <p style="margin-top: 24px;">Nếu bạn không yêu cầu đặt lại mật khẩu, vui lòng bỏ qua email này.</p>
                        </div>
                        <div class="footer">
                            <p>© 2025 PhoneCard68. All rights reserved.</p>
                            <p>Email này được gửi tự động, vui lòng không trả lời.</p>
                        </div>
                    </div>
                </body>
                </html>
                """.formatted(resetToken);
            
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_FROM, "PhoneCard68"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("🔐 Mã OTP đặt lại mật khẩu - PhoneCard68");
            message.setContent(htmlContent, "text/html; charset=UTF-8");
            
            Transport.send(message);
            System.out.println("Email sent successfully to: " + toEmail);
            return true;
            
        } catch (Exception e) {
            System.err.println("Failed to send email to: " + toEmail);
            e.printStackTrace();
            return false;
        }
    }
    
    public static boolean sendPasswordChangedNotification(String toEmail, String username) {
        try {
            Session session = Session.getInstance(getMailProperties(), new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(EMAIL_FROM, EMAIL_PASSWORD);
                }
            });
            
            String htmlContent = """
                <!DOCTYPE html>
                <html>
                <head>
                    <meta charset="UTF-8">
                    <style>
                        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f7fa; margin: 0; padding: 0; }
                        .container { max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 20px rgba(0,0,0,0.1); }
                        .header { background: linear-gradient(135deg, #10b981, #059669); padding: 40px 30px; text-align: center; }
                        .header h1 { color: #ffffff; margin: 0; font-size: 28px; }
                        .content { padding: 40px 30px; }
                        .content p { color: #4b5563; line-height: 1.6; margin-bottom: 20px; }
                        .success-box { background-color: #d1fae5; border-left: 4px solid #10b981; padding: 15px; border-radius: 6px; }
                        .success-box p { color: #065f46; margin: 0; }
                        .footer { background-color: #f9fafb; padding: 20px 30px; text-align: center; border-top: 1px solid #e5e7eb; }
                        .footer p { color: #9ca3af; font-size: 13px; margin: 5px 0; }
                    </style>
                </head>
                <body>
                    <div class="container">
                        <div class="header">
                            <h1>✅ Mật khẩu đã thay đổi</h1>
                        </div>
                        <div class="content">
                            <p>Xin chào <strong>%s</strong>,</p>
                            
                            <div class="success-box">
                                <p>✅ Mật khẩu tài khoản của bạn đã được đặt lại thành công.</p>
                            </div>
                            
                            <p style="margin-top: 20px;">Nếu bạn không thực hiện thay đổi này, vui lòng liên hệ ngay với chúng tôi hoặc đổi mật khẩu ngay lập tức.</p>
                            
                            <p>Trân trọng,<br>PhoneCard68 Team</p>
                        </div>
                        <div class="footer">
                            <p>© 2025 PhoneCard68. All rights reserved.</p>
                        </div>
                    </div>
                </body>
                </html>
                """.formatted(username);
            
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_FROM, "PhoneCard68"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("✅ Mật khẩu đã được thay đổi - PhoneCard68");
            message.setContent(htmlContent, "text/html; charset=UTF-8");
            
            Transport.send(message);
            return true;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean sendVerificationEmail(String toEmail, String token, String baseUrl) {
        try {
            Session session = Session.getInstance(getMailProperties(), new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(EMAIL_FROM, EMAIL_PASSWORD);
                }
            });

            String verifyLink = baseUrl + "/auth?action=verify&token=" + token;

            String htmlContent = """
                <!DOCTYPE html>
                <html>
                <head>
                    <meta charset="UTF-8">
                    <style>
                        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f7fa; margin: 0; padding: 0; }
                        .container { max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 20px rgba(0,0,0,0.1); }
                        .header { background: linear-gradient(135deg, #2563eb, #7c3aed); padding: 40px 30px; text-align: center; }
                        .header h1 { color: #ffffff; margin: 0; font-size: 28px; }
                        .content { padding: 40px 30px; }
                        .content p { color: #4b5563; line-height: 1.6; margin-bottom: 20px; }
                        .btn { display: inline-block; background: linear-gradient(135deg, #2563eb, #7c3aed); color: #ffffff !important; text-decoration: none; padding: 14px 36px; border-radius: 10px; font-weight: bold; margin: 20px 0; }
                        .btn:hover { opacity: 0.95; }
                        .footer { background-color: #f9fafb; padding: 20px 30px; text-align: center; border-top: 1px solid #e5e7eb; }
                        .footer p { color: #9ca3af; font-size: 13px; margin: 5px 0; }
                    </style>
                </head>
                <body>
                    <div class="container">
                        <div class="header">
                            <h1>✔️ Xác thực tài khoản</h1>
                        </div>
                        <div class="content">
                            <p>Cảm ơn bạn đã đăng ký PhoneCard68.</p>
                            <p>Nhấn nút bên dưới để xác thực email và kích hoạt tài khoản:</p>
                            <div style="text-align: center;">
                                <a href="%s" class="btn">Xác thực email</a>
                            </div>
                            <p style="margin-top: 30px;">Nếu nút không hoạt động, copy và paste link sau vào trình duyệt:</p>
                            <p style="word-break: break-all; color: #2563eb; font-size: 13px;">%s</p>
                        </div>
                        <div class="footer">
                            <p>© 2025 PhoneCard68. All rights reserved.</p>
                            <p>Email này được gửi tự động, vui lòng không trả lời.</p>
                        </div>
                    </div>
                </body>
                </html>
                """.formatted(verifyLink, verifyLink);

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_FROM, "PhoneCard68"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("✔️ Xác thực tài khoản - PhoneCard68");
            message.setContent(htmlContent, "text/html; charset=UTF-8");

            Transport.send(message);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}

