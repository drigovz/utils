using iText.Html2pdf;
using iText.Kernel.Geom;
using iText.Kernel.Pdf;
using System;
using System.IO;
using System.Text;

namespace Utils.PDF.Utilities
{
    public class PdfUtilities
    {
        public byte[] ConvertPDFtoByteArray(Stream html)
        {
            byte[] buffer;
            using (MemoryStream memStream = new())
            {
                WriterProperties wp = new();
                using (PdfWriter writer = new(memStream, wp))
                {
                    writer.SetCloseStream(true);

                    PdfDocument document;
                    using (document = new PdfDocument(writer))
                    {
                        ConverterProperties props = new();

                        document.SetDefaultPageSize(PageSize.LETTER);
                        document.SetCloseWriter(true);
                        document.SetCloseReader(true);
                        document.SetFlushUnusedObjects(true);
                        HtmlConverter.ConvertToPdf(html, document, props);

                        document.Close();
                    }
                }
                
                buffer = memStream.ToArray();
            }

            return buffer;
        }

        public string EncryptPDFwithPassword(byte[] bytes, string passwordUser, string passwordOwner)
        {
            string encryptedBase64 = string.Empty;
            byte[] userPassword = Encoding.ASCII.GetBytes(passwordUser),
                   ownerPassword = Encoding.ASCII.GetBytes(passwordOwner);

            PdfReader reader = new(new MemoryStream(bytes));
            WriterProperties wp = new WriterProperties()
                                .SetStandardEncryption(userPassword, ownerPassword,
                                EncryptionConstants.ALLOW_PRINTING,
                                EncryptionConstants.ENCRYPTION_AES_128 |
                                EncryptionConstants.DO_NOT_ENCRYPT_METADATA);

            using (var stream = new MemoryStream())
            {
                PdfWriter writer = new(stream, wp);
                PdfDocument doc = new(reader, writer);
                doc.Close();
                encryptedBase64 = Convert.ToBase64String(stream.ToArray());
            }

            return encryptedBase64;
        }

        public string ConvertPDFtoBase64String(byte[] bytes)
        {
            string encryptedBase64 = string.Empty;

            PdfReader reader = new(new MemoryStream(bytes));
            WriterProperties wp = new();

            using (var stream = new MemoryStream())
            {
                PdfWriter writer = new(stream, wp);
                PdfDocument doc = new(reader, writer);
                doc.Close();
                encryptedBase64 = Convert.ToBase64String(stream.ToArray());
            }

            return encryptedBase64;
        }
    }
}
