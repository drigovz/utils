using System;
using System.IO;
using Utils.PDF.Utilities;

namespace Utils.PDF
{
    public static class GeneratePdf
    {
        /// <summary>
        /// Generate PDF file with password from HTML String
        /// </summary>
        /// <param name="html">HTML string with content of convert in pdf file</param>
        /// <param name="path">Path where save pdf file</param>
        /// <returns>Path with encrypted pdf file created</returns>
        public static string GeneratePdfwithPassword(string html, string path, string userPassword)
        {
            if (html is null || path is null || userPassword is null)
                return null;
            
            try
            {
                string file = $@"{path}\{Guid.NewGuid()}.pdf";
                PdfUtilities utils = new();

                using (Stream stream = GenerateStreamFromString(html))
                {
                    var pdfBytes = utils.ConvertPDFtoByteArray(stream);
                    var base64String = utils.EncryptPDFwithPassword(pdfBytes, userPassword, userPassword);
                    var bytes = Convert.FromBase64String(base64String);
                    File.WriteAllBytes(file, bytes);
                    return file;
                }
            }
            catch
            {
                return null;
            }
        }

        /// <summary>
        /// Generate PDF file from HTML String
        /// </summary>
        /// <param name="html">HTML string with content of convert in pdf file</param>
        /// <param name="path">Path where save pdf file</param>
        /// <returns>Path with pdf file created</returns>
        public static string GeneratePdfFromString(string html, string path)
        {
            try
            {
                string file = $@"{path}\{Guid.NewGuid()}.pdf";
                PdfUtilities utils = new();

                using (Stream htmlSource = GenerateStreamFromString(html))
                {
                    var pdfBytes = utils.ConvertPDFtoByteArray(htmlSource);
                    var base64String = utils.ConvertPDFtoBase64String(pdfBytes);
                    var bytes = Convert.FromBase64String(base64String);
                    File.WriteAllBytes(file, bytes);
                    return file;
                }
            }
            catch
            {
                return null;
            }
        }

        public static Stream GenerateStreamFromString(string s)
        {
            var stream = new MemoryStream();
            var writer = new StreamWriter(stream);
            writer.Write(s);
            writer.Flush();
            stream.Position = 0;
            return stream;
        }
    }
}
