using Microsoft.AspNetCore.Cryptography.KeyDerivation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Threading.Tasks;

namespace ArsApi.Utils
{
    public static class AppUtils
    {
        public static string CreateRandomString(string prefix, int length)
        {
            string str = "";
            Random random = new Random();
            for (int i = 0; i < length; i++)
            {
                double flt = random.NextDouble();
                int shift = Convert.ToInt32(Math.Floor(10 * flt));
                str += shift;
            }
            if(!string.IsNullOrEmpty(prefix))
            {
                str = prefix + str;
            }
            return str;
        }
        public static string CreateEmailConfirmContent(string customername, string customerNumber, string code)
        {
            return 
            @$"<div>
                <p style='color: #00558f; margin-bottom: 10px;'>Dear <span style = 'font-weight: bold;'>{customername}</span>.</p>
                <p style='color: #00558f; margin-bottom: 10px;'>
                  Thank you for signing up for an Ars Airways account.<br>
                  Your membership number: <span style='font-weight: bold'>{customerNumber}</span>.
                </p>
                <p style='color: #00558f; margin-bottom: 10px;'>
                    To continue, please enter the verification code:
                    <span style='font-size:18px;display: inline-block; background: #8cd660; 
                    padding: 8px 20px; color: #fff; font-weight: bold; border-radius: 4px;'>{code}</span>
                </p>
                <p style='color: #00558f'>Sincerely thank you!</p>
            </div>";
        }
        public static string CreateEmailActiveAccount(string customerName, string customerNo, string customerNoParam)
        {
            return
            @$"<div>
                <p style='color: #00558f; margin-bottom: 10px;'>Dear <span style = 'font-weight: bold;'>{customerName}</span>.</p>
                <p style='color: #00558f; margin-bottom: 10px;'>
                  Thank you for signing up for an Ars Airways account. 
                  <br>
                  Your membership number: <span style='font-weight: bold'>{customerNo}</span>.
                </p>
                <p style='color: #00558f; margin-bottom: 10px;'>
                    To continue, please enter the verification code:
                    <a href='http://localhost:3000/active-account/{customerNoParam}'
                    target='_blank'
                    style ='font-size:16px;display: inline-block; background: #8cd660; 
                    padding: 6px 10px; color: #fff; font-weight: bold; border-radius: 4px;text-decoration: none;'>
                    Click here to continue.</a>
                </p>
                <p style='color: #00558f'>Sincerely thank you!</p>
            </div>";
        }
        public static string HashString(string str, string salt = "YXJzYWlyd2F5c3NlY3JldHNlY3VyaXR5Y29kZQ==")
        {
            string hashed = Convert.ToBase64String(KeyDerivation.Pbkdf2(
            password: str,
            salt: Convert.FromBase64String(salt),
            prf: KeyDerivationPrf.HMACSHA1,
            iterationCount: 10000,
            numBytesRequested: 256 / 8));
            return hashed;
        }
        public static string CreateRandomSalt()
        {
            byte[] salt = new byte[128 / 8];
            using (var rng = RandomNumberGenerator.Create())
            {
                rng.GetBytes(salt);
            }
            return Convert.ToBase64String(salt);
        }
    }
}
