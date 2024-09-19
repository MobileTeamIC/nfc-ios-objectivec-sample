//
//  ViewController.m
//  NFCSampleObjectiveC
//
//  Created by MinhMinhMinh on 19/09/2024.
//

#import "ViewController.h"
@import ICNFCCardReader;

@interface ViewController ()<ICMainNFCReaderDelegate>

@property (weak, nonatomic) IBOutlet UIButton *buttonStart_QR_NFC;
@property (weak, nonatomic) IBOutlet UIButton *buttonStart_MRZ_NFC;
@property (weak, nonatomic) IBOutlet UIButton *buttonStart_Only_NFC;
@property (weak, nonatomic) IBOutlet UIButton *buttonStart_Only_NFC_WithoutUI;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.buttonStart_QR_NFC setTitle:@"QR → NFC" forState:UIControlStateNormal];
    [self.buttonStart_QR_NFC setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.buttonStart_QR_NFC.layer.cornerRadius = 6.0f;
    [self.buttonStart_QR_NFC addTarget:self action:@selector(actionStart_QR_NFC) forControlEvents:UIControlEventTouchUpInside];
    
    [self.buttonStart_MRZ_NFC setTitle:@"MRZ → NFC" forState:UIControlStateNormal];
    [self.buttonStart_MRZ_NFC setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.buttonStart_MRZ_NFC.layer.cornerRadius = 6.0f;
    [self.buttonStart_MRZ_NFC addTarget:self action:@selector(actionStart_MRZ_NFC) forControlEvents:UIControlEventTouchUpInside];
    
    [self.buttonStart_Only_NFC setTitle:@"Only NFC" forState:UIControlStateNormal];
    [self.buttonStart_Only_NFC setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.buttonStart_Only_NFC.layer.cornerRadius = 6.0f;
    [self.buttonStart_Only_NFC addTarget:self action:@selector(actionStart_Only_NFC) forControlEvents:UIControlEventTouchUpInside];
    
    [self.buttonStart_Only_NFC_WithoutUI setTitle:@"Only NFC Without UI" forState:UIControlStateNormal];
    [self.buttonStart_Only_NFC_WithoutUI setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.buttonStart_Only_NFC_WithoutUI.layer.cornerRadius = 6.0f;
    [self.buttonStart_Only_NFC_WithoutUI addTarget:self action:@selector(actionStart_Only_NFC_WithoutUI) forControlEvents:UIControlEventTouchUpInside];
    
    // Nhập thông tin bộ mã truy cập. Lấy tại mục Quản lý Token https://ekyc.vnpt.vn/admin-dashboard/console/project-manager
    [ICNFCSaveData shared].SDTokenId = [NSString string];
    [ICNFCSaveData shared].SDTokenKey = [NSString string];
    [ICNFCSaveData shared].SDAuthorization = [NSString string];
    
    // Hiển thị LOG các request được gọi trong SDK
    [ICNFCSaveData shared].isPrintLogRequest = true;
    
}



- (void) actionStart_QR_NFC {
    
    // Chức năng đọc thông tin thẻ chip bằng NFC, từ iOS 13.0 trở lên
    ICMainNFCReaderViewController *objICMainNFCReader = (ICMainNFCReaderViewController *)[ICMainNFCReaderRouter createModule];
    
    /*========== CÁC THUỘC TÍNH CHÍNH ==========*/
    
    // Đặt giá trị DELEGATE để nhận kết quả trả về
    objICMainNFCReader.icMainNFCDelegate = self;
    
    // Giá trị này xác định ngôn ngữ được sử dụng trong SDK.
    // - icnfc_vi: Tiếng Việt
    // - icnfc_en: Tiếng Anh
    objICMainNFCReader.languageSdk = @"icekyc_vi";
    
    // Giá trị này xác định việc có hiển thị màn hình trợ giúp hay không.
    objICMainNFCReader.isShowTutorial = true;
    
    // Bật chức năng hiển thị nút bấm "Bỏ qua hướng dẫn" tại các màn hình hướng dẫn bằng video. Mặc định false (Không hiện)
    // Bật chức năng hiển thị nút bấm "Bỏ qua hướng dẫn".
    objICMainNFCReader.isEnableGotIt = true;
    
    // Thuộc tính quy định việc đọc thông tin NFC
    // - QRCode: Quét mã QR sau đó đọc thông tin thẻ Chip NFC
    // - MRZCode: Quét mã MRZ sau đó đọc thông tin thẻ Chip NFC
    // - NFCReader: Nhập thông tin cho Số thẻ, ngày sinh và ngày hết hạn
    // => sau đó đọc thông tin thẻ Chip NFC
    objICMainNFCReader.cardReaderStep = QRCode;
    // Trường hợp cardReaderStep là NFCReader thì mới cần truyền 03 thông tin idNumberCard, birthdayCard, expiredDateCard
    // Số giấy tờ căn cước, là dãy số gồm 12 ký tự.
    // objICMainNFCReader.idNumberCard = self.idNumber
    // Ngày sinh trên Căn cước, có định dạng YYMMDD (ví dụ 18 tháng 5 năm 1978 thì giá trị là 780518).
    // objICMainNFCReader.birthdayCard = self.birthday
    // Ngày hết hạn của Căn cước, có định dạng YYMMDD (ví dụ 18 tháng 5 năm 2047 thì giá trị là 470518).
    // objICMainNFCReader.expiredDateCard = self.expiredDate
    
    // bật chức năng tải ảnh chân dung trong CCCD để lấy mã ảnh tại ICNFCSaveData.shared().hashImageAvatar
    objICMainNFCReader.isEnableUploadAvatarImage = true;
    
    // Bật tính năng Matching Postcode, để lấy thông tin mã khu vực
    // Thông tin mã Quê quán tại ICNFCSaveData.shared().postcodePlaceOfOriginResult
    // Thông tin mã Nơi thường trú tại ICNFCSaveData.shared().postcodePlaceOfResidenceResult
    objICMainNFCReader.isGetPostcodeMatching = false;
    
    // bật tính năng xác minh thông tin thẻ với C06 Bộ công an. lấy giá trị tại ICNFCSaveData.shared().verifyNFCCardResult
    // objICMainNFCReader.isEnableVerifyChipC06 = false
    
    // bật hoặc tắt tính năng Call Service. Mặc định false (Thực hiện bật chức năng Call Service)
    objICMainNFCReader.isTurnOffCallService = false;
    
    // Giá trị này được truyền vào để xác định nhiều luồng giao dịch trong một phiên. Mặc định ""
    // Ví dụ sau khi Khách hàng thực hiện eKYC => sẽ sinh ra 01 ClientSession
    // Khách hàng sẽ truyền ClientSession vào giá trị này => khi đó eKYC và NFC sẽ có chung ClientSession
    // => tra xuất dữ liệu sẽ dễ hơn trong quá trình đối soát
    objICMainNFCReader.inputClientSession = [NSString string];
    
    // Giá trị này được truyền vào để xác định các thông tin cần để đọc. Các phần tử truyền vào là các giá trị của CardReaderValues.
    // Trường hợp KHÔNG truyền readingTagsNFC => sẽ thực hiện đọc hết tất cả
    // Trường hợp CÓ truyền giá trị cho readingTagsNFC => sẽ đọc các thông tin truyền vào và mã DG13
    // VerifyDocumentInfo - Thông tin bảo mật thẻ
    // MRZInfo - Thông tin mã MRZ
    // ImageAvatarInfo - Thông tin ảnh chân dung trong thẻ
    // SecurityDataInfo - Thông tin bảo vệ thẻ
    objICMainNFCReader.readingTagsNFC = [[NSArray alloc] init];
    
    
    objICMainNFCReader.modalPresentationStyle = UIModalPresentationFullScreen;
    objICMainNFCReader.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:objICMainNFCReader animated:YES completion:nil];
}

- (void) actionStart_MRZ_NFC {
    
    // Chức năng đọc thông tin thẻ chip bằng NFC, từ iOS 13.0 trở lên
    ICMainNFCReaderViewController *objICMainNFCReader = (ICMainNFCReaderViewController *)[ICMainNFCReaderRouter createModule];
    
    /*========== CÁC THUỘC TÍNH CHÍNH ==========*/
    
    // Đặt giá trị DELEGATE để nhận kết quả trả về
    objICMainNFCReader.icMainNFCDelegate = self;
    
    // Giá trị này xác định ngôn ngữ được sử dụng trong SDK.
    // - icnfc_vi: Tiếng Việt
    // - icnfc_en: Tiếng Anh
    objICMainNFCReader.languageSdk = @"icekyc_vi";
    
    // Giá trị này xác định việc có hiển thị màn hình trợ giúp hay không.
    objICMainNFCReader.isShowTutorial = true;
    
    // Bật chức năng hiển thị nút bấm "Bỏ qua hướng dẫn" tại các màn hình hướng dẫn bằng video. Mặc định false (Không hiện)
    // Bật chức năng hiển thị nút bấm "Bỏ qua hướng dẫn".
    objICMainNFCReader.isEnableGotIt = true;
    
    // Thuộc tính quy định việc đọc thông tin NFC
    // - QRCode: Quét mã QR sau đó đọc thông tin thẻ Chip NFC
    // - MRZCode: Quét mã MRZ sau đó đọc thông tin thẻ Chip NFC
    // - NFCReader: Nhập thông tin cho Số thẻ, ngày sinh và ngày hết hạn
    // => sau đó đọc thông tin thẻ Chip NFC
    objICMainNFCReader.cardReaderStep = QRCode;
    // Trường hợp cardReaderStep là NFCReader thì mới cần truyền 03 thông tin idNumberCard, birthdayCard, expiredDateCard
    // Số giấy tờ căn cước, là dãy số gồm 12 ký tự.
    // objICMainNFCReader.idNumberCard = self.idNumber
    // Ngày sinh trên Căn cước, có định dạng YYMMDD (ví dụ 18 tháng 5 năm 1978 thì giá trị là 780518).
    // objICMainNFCReader.birthdayCard = self.birthday
    // Ngày hết hạn của Căn cước, có định dạng YYMMDD (ví dụ 18 tháng 5 năm 2047 thì giá trị là 470518).
    // objICMainNFCReader.expiredDateCard = self.expiredDate
    
    // bật chức năng tải ảnh chân dung trong CCCD để lấy mã ảnh tại ICNFCSaveData.shared().hashImageAvatar
    objICMainNFCReader.isEnableUploadAvatarImage = true;
    
    // Bật tính năng Matching Postcode, để lấy thông tin mã khu vực
    // Thông tin mã Quê quán tại ICNFCSaveData.shared().postcodePlaceOfOriginResult
    // Thông tin mã Nơi thường trú tại ICNFCSaveData.shared().postcodePlaceOfResidenceResult
    objICMainNFCReader.isGetPostcodeMatching = false;
    
    // bật tính năng xác minh thông tin thẻ với C06 Bộ công an. lấy giá trị tại ICNFCSaveData.shared().verifyNFCCardResult
    // objICMainNFCReader.isEnableVerifyChipC06 = false
    
    // bật hoặc tắt tính năng Call Service. Mặc định false (Thực hiện bật chức năng Call Service)
    objICMainNFCReader.isTurnOffCallService = false;
    
    // Giá trị này được truyền vào để xác định nhiều luồng giao dịch trong một phiên. Mặc định ""
    // Ví dụ sau khi Khách hàng thực hiện eKYC => sẽ sinh ra 01 ClientSession
    // Khách hàng sẽ truyền ClientSession vào giá trị này => khi đó eKYC và NFC sẽ có chung ClientSession
    // => tra xuất dữ liệu sẽ dễ hơn trong quá trình đối soát
    objICMainNFCReader.inputClientSession = [NSString string];
    
    // Giá trị này được truyền vào để xác định các thông tin cần để đọc. Các phần tử truyền vào là các giá trị của CardReaderValues.
    // Trường hợp KHÔNG truyền readingTagsNFC => sẽ thực hiện đọc hết tất cả
    // Trường hợp CÓ truyền giá trị cho readingTagsNFC => sẽ đọc các thông tin truyền vào và mã DG13
    // VerifyDocumentInfo - Thông tin bảo mật thẻ
    // MRZInfo - Thông tin mã MRZ
    // ImageAvatarInfo - Thông tin ảnh chân dung trong thẻ
    // SecurityDataInfo - Thông tin bảo vệ thẻ
    objICMainNFCReader.readingTagsNFC = [[NSArray alloc] init];
    
    
    objICMainNFCReader.modalPresentationStyle = UIModalPresentationFullScreen;
    objICMainNFCReader.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:objICMainNFCReader animated:YES completion:nil];
}

- (void) actionStart_Only_NFC {
    
    // Số giấy tờ căn cước, là dãy số gồm 12 ký tự. (ví dụ 123456789000)
    NSString *idNumber = [NSString string];
    // Ngày sinh của người dùng được in trên Căn cước, có định dạng YYMMDD (ví dụ 18 tháng 5 năm 1978 thì giá trị là 780518).
    NSString *birthday = [NSString string];
    // Ngày hết hạn của Căn cước, có định dạng YYMMDD (ví dụ 18 tháng 5 năm 2047 thì giá trị là 470518).
    NSString *expiredDate = [NSString string];

    
    // Chức năng đọc thông tin thẻ chip bằng NFC, từ iOS 13.0 trở lên
    ICMainNFCReaderViewController *objICMainNFCReader = (ICMainNFCReaderViewController *)[ICMainNFCReaderRouter createModule];
    
    /*========== CÁC THUỘC TÍNH CHÍNH ==========*/
    
    // Đặt giá trị DELEGATE để nhận kết quả trả về
    objICMainNFCReader.icMainNFCDelegate = self;
    
    // Giá trị này xác định ngôn ngữ được sử dụng trong SDK.
    // - icnfc_vi: Tiếng Việt
    // - icnfc_en: Tiếng Anh
    objICMainNFCReader.languageSdk = @"icekyc_vi";
    
    // Giá trị này xác định việc có hiển thị màn hình trợ giúp hay không.
    objICMainNFCReader.isShowTutorial = true;
    
    // Bật chức năng hiển thị nút bấm "Bỏ qua hướng dẫn" tại các màn hình hướng dẫn bằng video. Mặc định false (Không hiện)
    // Bật chức năng hiển thị nút bấm "Bỏ qua hướng dẫn".
    objICMainNFCReader.isEnableGotIt = true;
    
    // Thuộc tính quy định việc đọc thông tin NFC
    // - QRCode: Quét mã QR sau đó đọc thông tin thẻ Chip NFC
    // - MRZCode: Quét mã MRZ sau đó đọc thông tin thẻ Chip NFC
    // - NFCReader: Nhập thông tin cho Số thẻ, ngày sinh và ngày hết hạn
    // => sau đó đọc thông tin thẻ Chip NFC
    objICMainNFCReader.cardReaderStep = NFCReader;
    // Trường hợp cardReaderStep là NFCReader thì mới cần truyền 03 thông tin idNumberCard, birthdayCard, expiredDateCard
    // Số giấy tờ căn cước, là dãy số gồm 12 ký tự.
    objICMainNFCReader.idNumberCard = idNumber;
    // Ngày sinh trên Căn cước, có định dạng YYMMDD (ví dụ 18 tháng 5 năm 1978 thì giá trị là 780518).
    objICMainNFCReader.birthdayCard = birthday;
    // Ngày hết hạn của Căn cước, có định dạng YYMMDD (ví dụ 18 tháng 5 năm 2047 thì giá trị là 470518).
    objICMainNFCReader.expiredDateCard = expiredDate;
    
    // bật chức năng tải ảnh chân dung trong CCCD để lấy mã ảnh tại ICNFCSaveData.shared().hashImageAvatar
    objICMainNFCReader.isEnableUploadAvatarImage = true;
    
    // Bật tính năng Matching Postcode, để lấy thông tin mã khu vực
    // Thông tin mã Quê quán tại ICNFCSaveData.shared().postcodePlaceOfOriginResult
    // Thông tin mã Nơi thường trú tại ICNFCSaveData.shared().postcodePlaceOfResidenceResult
    objICMainNFCReader.isGetPostcodeMatching = false;
    
    // bật tính năng xác minh thông tin thẻ với C06 Bộ công an. lấy giá trị tại ICNFCSaveData.shared().verifyNFCCardResult
    // objICMainNFCReader.isEnableVerifyChipC06 = false
    
    // bật hoặc tắt tính năng Call Service. Mặc định false (Thực hiện bật chức năng Call Service)
    objICMainNFCReader.isTurnOffCallService = false;
    
    // Giá trị này được truyền vào để xác định nhiều luồng giao dịch trong một phiên. Mặc định ""
    // Ví dụ sau khi Khách hàng thực hiện eKYC => sẽ sinh ra 01 ClientSession
    // Khách hàng sẽ truyền ClientSession vào giá trị này => khi đó eKYC và NFC sẽ có chung ClientSession
    // => tra xuất dữ liệu sẽ dễ hơn trong quá trình đối soát
    objICMainNFCReader.inputClientSession = [NSString string];
    
    // Giá trị này được truyền vào để xác định các thông tin cần để đọc. Các phần tử truyền vào là các giá trị của CardReaderValues.
    // Trường hợp KHÔNG truyền readingTagsNFC => sẽ thực hiện đọc hết tất cả
    // Trường hợp CÓ truyền giá trị cho readingTagsNFC => sẽ đọc các thông tin truyền vào và mã DG13
    // VerifyDocumentInfo - Thông tin bảo mật thẻ
    // MRZInfo - Thông tin mã MRZ
    // ImageAvatarInfo - Thông tin ảnh chân dung trong thẻ
    // SecurityDataInfo - Thông tin bảo vệ thẻ
    objICMainNFCReader.readingTagsNFC = [[NSArray alloc] init];
    
    
    objICMainNFCReader.modalPresentationStyle = UIModalPresentationFullScreen;
    objICMainNFCReader.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:objICMainNFCReader animated:YES completion:nil];
}

- (void) actionStart_Only_NFC_WithoutUI {
    
    // Số giấy tờ căn cước, là dãy số gồm 12 ký tự. (ví dụ 123456789000)
    NSString *idNumber = [NSString string];
    // Ngày sinh của người dùng được in trên Căn cước, có định dạng YYMMDD (ví dụ 18 tháng 5 năm 1978 thì giá trị là 780518).
    NSString *birthday = [NSString string];
    // Ngày hết hạn của Căn cước, có định dạng YYMMDD (ví dụ 18 tháng 5 năm 2047 thì giá trị là 470518).
    NSString *expiredDate = [NSString string];
    
    // Chức năng đọc thông tin thẻ chip bằng NFC, từ iOS 13.0 trở lên
    ICMainNFCReaderViewController *objICMainNFCReader = (ICMainNFCReaderViewController *)[ICMainNFCReaderRouter createModule];
    
    /*========== CÁC THUỘC TÍNH CHÍNH ==========*/
    
    // Đặt giá trị DELEGATE để nhận kết quả trả về
    objICMainNFCReader.icMainNFCDelegate = self;
    
    // Giá trị này xác định ngôn ngữ được sử dụng trong SDK.
    // - icnfc_vi: Tiếng Việt
    // - icnfc_en: Tiếng Anh
    objICMainNFCReader.languageSdk = @"icekyc_vi";
    
    // Giá trị này xác định việc có hiển thị màn hình trợ giúp hay không.
    objICMainNFCReader.isShowTutorial = true;
    
    // Bật chức năng hiển thị nút bấm "Bỏ qua hướng dẫn" tại các màn hình hướng dẫn bằng video. Mặc định false (Không hiện)
    // Bật chức năng hiển thị nút bấm "Bỏ qua hướng dẫn".
    objICMainNFCReader.isEnableGotIt = true;
    
    // Thuộc tính quy định việc đọc thông tin NFC
    // - QRCode: Quét mã QR sau đó đọc thông tin thẻ Chip NFC
    // - MRZCode: Quét mã MRZ sau đó đọc thông tin thẻ Chip NFC
    // - NFCReader: Nhập thông tin cho Số thẻ, ngày sinh và ngày hết hạn
    // => sau đó đọc thông tin thẻ Chip NFC
    objICMainNFCReader.cardReaderStep = NFCReader;
    // Trường hợp cardReaderStep là NFCReader thì mới cần truyền 03 thông tin idNumberCard, birthdayCard, expiredDateCard
    // Số giấy tờ căn cước, là dãy số gồm 12 ký tự.
    // objICMainNFCReader.idNumberCard = self.idNumber
    // Ngày sinh trên Căn cước, có định dạng YYMMDD (ví dụ 18 tháng 5 năm 1978 thì giá trị là 780518).
    // objICMainNFCReader.birthdayCard = self.birthday
    // Ngày hết hạn của Căn cước, có định dạng YYMMDD (ví dụ 18 tháng 5 năm 2047 thì giá trị là 470518).
    // objICMainNFCReader.expiredDateCard = self.expiredDate
    
    // bật chức năng tải ảnh chân dung trong CCCD để lấy mã ảnh tại ICNFCSaveData.shared().hashImageAvatar
    objICMainNFCReader.isEnableUploadAvatarImage = true;
    
    // Bật tính năng Matching Postcode, để lấy thông tin mã khu vực
    // Thông tin mã Quê quán tại ICNFCSaveData.shared().postcodePlaceOfOriginResult
    // Thông tin mã Nơi thường trú tại ICNFCSaveData.shared().postcodePlaceOfResidenceResult
    objICMainNFCReader.isGetPostcodeMatching = false;
    
    // bật tính năng xác minh thông tin thẻ với C06 Bộ công an. lấy giá trị tại ICNFCSaveData.shared().verifyNFCCardResult
    // objICMainNFCReader.isEnableVerifyChipC06 = false
    
    // bật hoặc tắt tính năng Call Service. Mặc định false (Thực hiện bật chức năng Call Service)
    objICMainNFCReader.isTurnOffCallService = false;
    
    // Giá trị này được truyền vào để xác định nhiều luồng giao dịch trong một phiên. Mặc định ""
    // Ví dụ sau khi Khách hàng thực hiện eKYC => sẽ sinh ra 01 ClientSession
    // Khách hàng sẽ truyền ClientSession vào giá trị này => khi đó eKYC và NFC sẽ có chung ClientSession
    // => tra xuất dữ liệu sẽ dễ hơn trong quá trình đối soát
    objICMainNFCReader.inputClientSession = [NSString string];
    
    // Giá trị này được truyền vào để xác định các thông tin cần để đọc. Các phần tử truyền vào là các giá trị của CardReaderValues.
    // Trường hợp KHÔNG truyền readingTagsNFC => sẽ thực hiện đọc hết tất cả
    // Trường hợp CÓ truyền giá trị cho readingTagsNFC => sẽ đọc các thông tin truyền vào và mã DG13
    // VerifyDocumentInfo - Thông tin bảo mật thẻ
    // MRZInfo - Thông tin mã MRZ
    // ImageAvatarInfo - Thông tin ảnh chân dung trong thẻ
    // SecurityDataInfo - Thông tin bảo vệ thẻ
    objICMainNFCReader.readingTagsNFC = [[NSArray alloc] init];
    
    
    objICMainNFCReader.modalPresentationStyle = UIModalPresentationFullScreen;
    objICMainNFCReader.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:objICMainNFCReader animated:YES completion:nil];
}




- (void)icNFCMainDismissed {
    
}

- (void)icNFCCardReaderGetResult {
    NSDictionary *dataNFCResult = [ICNFCSaveData shared].dataNFCResult;
    NSDictionary *dataGroupsResult = [ICNFCSaveData shared].dataGroupsResult;
}

@end
