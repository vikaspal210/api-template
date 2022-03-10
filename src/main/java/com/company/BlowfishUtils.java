package com.company;

import java.util.Base64;
import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

public class BlowfishUtils {

	public final static String decrypt2(String key, String encryptedData) {
		try {
			byte[] decoded = Base64.getDecoder().decode(encryptedData.getBytes("UTF-8"));
			Cipher cipher = Cipher.getInstance("Blowfish/CBC/PKCS5Padding");
			byte[] keyBytes = key.getBytes("UTF-8");
			byte[] iv = new byte[cipher.getBlockSize()];
			for (int i=0; i<cipher.getBlockSize(); i++) {
				iv[i] = keyBytes[i];
			}
			IvParameterSpec ivSpec = new IvParameterSpec(iv);
			SecretKey secretKey = new SecretKeySpec(keyBytes, "Blowfish");
			cipher.init(Cipher.DECRYPT_MODE, secretKey, ivSpec);
			byte[] decrypted = cipher.doFinal(decoded);
			return new String(decrypted);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

}
