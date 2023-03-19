using FluentAssertions;
using System;
using System.IO;
using Utils.PDF.Utilities;
using Xunit;

namespace Utils.PDF.Test
{
    public class GeneratePdfTest
    {
        [Fact]
        [Trait("PDF", "GeneratePdf")]
        public void Should_Return_PDF_File()
        {
            PdfUtilities utils = new();
            string html = @"<!DOCTYPE html>
                            <html lang=""en"">
                            <head>
                                <meta charset=""UTF-8"" />
                                <meta http-equiv=""X-UA-Compatible"" content=""IE=edge"" />
                                <meta name=""viewport"" content=""width=device-width, initial-scale=1.0"" />
                                <title>Hello World!</title>
                            </head>
                            <body>
                                <h1>Hello World!</h1>
                            </body>
                            </html>",
                    file = $@"{Directory.GetCurrentDirectory()}\pdfs\{Guid.NewGuid()}.pdf"
                    .Replace("\\bin\\Debug\\net5.0", "");

            try
            {
                using (Stream stream = GeneratePdf.GenerateStreamFromString(html))
                {
                    var pdfBytes = utils.ConvertPDFtoByteArray(stream);
                    var base64String = utils.EncryptPDFwithPassword(pdfBytes, "user", "user");
                    var bytes = Convert.FromBase64String(base64String);
                    File.WriteAllBytes(file, bytes);

                    (pdfBytes.Length > 0).Should().BeTrue();
                    (base64String.Length > 0).Should().BeTrue();
                    (bytes.Length > 0).Should().BeTrue();
                }
            }
            catch
            {
                file = null;
            }

            file.Should().NotBeNullOrEmpty();
            File.Exists(file).Should().BeTrue();

            if (File.Exists(file))
                File.Delete(file);
        }
    }
}
