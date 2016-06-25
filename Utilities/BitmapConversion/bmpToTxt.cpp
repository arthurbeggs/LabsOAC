#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <iostream>
#include <cstdio>
#include <cstdlib>
#include <string>
#include <vector>
#include <fstream>
#include <sstream>
#include <iomanip>

using namespace cv;
using namespace std;

std::string int_to_hex( int i )
{
    std::stringstream stream;
    stream << std::setfill ('0') << std::setw(sizeof(uchar)*2) 
           << std::hex << i;
    return stream.str();
}

int main()
{
    string fileNameOut, imageNameIn;
    cout << "Digite o nome da imagem .bmp (com a extensao!): " << endl;
    cin >> imageNameIn;
    Mat image;
    image = imread(imageNameIn, CV_LOAD_IMAGE_COLOR);

    if (!image.data)
    {
        cerr << "Error! image is invalid!" << endl;
        return 0;
    }

    fileNameOut = imageNameIn;
    fileNameOut.erase(fileNameOut.end()-4, fileNameOut.end());
    fileNameOut = fileNameOut + "_hex.txt";
    ofstream fileOut;
    fileOut.open(fileNameOut.c_str());

    namedWindow("Imagem:", WINDOW_AUTOSIZE);

    fileOut << "WIDTH: " << image.cols << "\n";
    fileOut << "HEIGHT: " << image.rows << "\n";

    for (int i = 0; i < image.rows; ++i)
    {
        for (int j = 0; j < image.cols; ++j)
        {
            int b, g, r;
            b = (int)image.data[image.channels()*(image.cols*i + j) + 0];
            g = (int)image.data[image.channels()*(image.cols*i + j) + 1];
            r = (int)image.data[image.channels()*(image.cols*i + j) + 2];
            b = floor(b*4/256);
            g = floor(g*8/256);
            r = floor(r*8/256);
            string resultado;
            b = b << 6;
            g = g << 3;
            r = r | g | b;

            resultado = int_to_hex(r);

            if (j == image.cols-1)
                fileOut << resultado << "\n";
            else
                fileOut << resultado << " ";
        }
    }
    return 0;
}
