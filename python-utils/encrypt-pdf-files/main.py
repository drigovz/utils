from PyPDF2 import PdfFileWriter, PdfFileReader


def secure_pdf(file_to_encrypt, password_encryption):
    parser = PdfFileWriter()
    pdf = PdfFileReader(file_to_encrypt)

    for page in range(pdf.numPages):
        parser.addPage(pdf.getPage(page))
    parser.encrypt(password_encryption)

    with open(f"encrypted_{file}", "wb") as f:
        parser.write(f)
        f.close()
    print(f"encrypted_{file} Created...")


if __name__ == "__main__":
    file = "files/test_file.pdf"
    password = "strongpass"
    secure_pdf(file, password)
