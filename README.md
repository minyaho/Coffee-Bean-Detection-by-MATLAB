# Coffee Bean Detection by MATLAB
## Purpose: 

Detect the coffee bean on the conveyor belt.

## Method: 

* First, convert images from the conveyor belt to grayscale images, and we can set an appropriate threshold to make grayscale one to binary one.
* Second, use the Image Morphology method to reduce the noise (eg. reflective light or dust) on the images. 
* Third, use the edge detection to the binary images, and use it to find out the objects on images. 
* Forth, calculate area of the objects, then find out the object which is maximum area. We can set an area threshold to judge it, if it is a coffee beans.
* Fifth, If the area bigger than area threshold, we can select it to be the coffee bean.
* Sixth, we finish the detection, and crop the object (coffee bean) image by 500*500 sizes, and store it.


# 藉由MATLAB實作咖啡豆辨識

## 目的: 

偵測出在輸送帶上的咖啡豆

## 方法:
1. 將傳送帶上的圖像轉換為灰度圖像，然後我們可以設置適當的閾值，以使灰度圖像變為二進製圖像。
2. 使用圖像形態學方法減少圖像上的噪點（例如反射光或灰塵）。
3. 對所處理的二值圖像進行邊緣檢測，並利用邊緣檢測找出圖像上的物體。 
4. 計算對象的面積，然後找出最大面積的對象。 我們可以設置面積閾值來判斷它是否是咖啡豆。
5. 如果面積大於面積閾值，我們可以選擇它作為咖啡豆。
6. 完成檢測，然後將對象（咖啡豆）圖像裁剪為500 * 500尺寸並存儲。

## 演算法
共8個STEP:
1. 將RGB影像im轉換成灰階影像imgy
2. 透過閥值gray_th將灰階影像imgy二值化成二元影像imb，使黑色為背景，輸送帶上的物件為白色。
3. 透過開運算imopen為二元影像imb去除光點雜訊
4. 透過邊緣偵測找出二元影像imb的邊緣資訊edge_im
5. 透過二元物件標記bwlabel找出邊緣資訊edge_im內的物件，被偵測到的每個物件將會被四個座標(X_min, X_max, Y_min, Y_max)框住，並將座標資訊放入mark_image集合中
6. 透過mark_image內的座標資訊計算每個物件面積，並將物件的面積資訊放入area_array
7. 透過設立適當的咖啡生豆面積門檻值area_th，來過濾area_array內的面積資訊，唯有大於等於門檻值才能被辨識成有咖啡生豆。
8. 如有大於等於面積門檻值的物件則抓出座標(X_min, X_max, Y_min, Y_max)，計算中心點，再裁切出500x500的目標(咖啡豆)影像。若無大於面積門檻值則標示成未偵測到咖啡豆。

