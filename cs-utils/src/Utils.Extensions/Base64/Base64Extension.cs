using System;

namespace Utils.Extensions.Base64
{
    public static class Base64Extension
    {
        /// <summary>
        /// Convert byte array to Base64 string
        /// </summary>
        /// <returns>base64 string</returns>
        public static string ByteArrayToBase64String(this byte[] fileBytes)
            => Convert.ToBase64String(fileBytes);

        /// <summary>
        /// Convert Base64 string to byte array
        /// </summary>
        /// <returns>byte array</returns>
        public static byte[] Base64StringToByteArray(this string base64)
            => Convert.FromBase64String(base64);
    }
}
