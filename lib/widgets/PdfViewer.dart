// import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';

// class PdfViewer extends StatefulWidget {
//   final String filePath;
//   final String filecode;
//   PdfViewer({required this.filePath, required this.filecode});

//   @override
//   _PdfViewerState createState() => _PdfViewerState();
// }

// class _PdfViewerState extends State<PdfViewer> {
//   late PDFViewController pdfViewController;

//   Future<void> _downloadPDF() async {
//     // Your download PDF logic here
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.filecode.toString()),
//         backgroundColor: Color(0xff63E55F),
//       ),
//       body: isLoading
//           ? Center(
//               child: CircularProgressIndicator(),
//             )
//           : Container(
//               width: MediaQuery.of(context)
//                   .size
//                   .width, // Take full width of screen
//               height: MediaQuery.of(context)
//                   .size
//                   .height, // Take full height of screen
//               child: PDFView(
//                 filePath: widget.filePath,
//                 onRender: (_pages) {
//                   // Do something when the PDF is rendered
//                 },
//                 onError: (error) {
//                   // Handle any errors that occur while rendering the PDF
//                 },
//                 onPageError: (page, error) {
//                   // Handle any errors that occur while rendering a specific page
//                 },
//                 onViewCreated: (PDFViewController pdfViewController) {
//                   this.pdfViewController = pdfViewController;
//                 },
//               ),
//             ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _downloadPDF,
//         child: Icon(Icons.download),
//         backgroundColor: Color(0xff63E55F),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfViewer extends StatefulWidget {
  final String filePath;
  final String filecode;
  PdfViewer({required this.filePath, required this.filecode});

  @override
  _PdfViewerState createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  late PDFViewController pdfViewController;
  bool isLoading = true; // Flag to track loading status

  Future<void> _downloadPDF() async {
    // Your download PDF logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.filecode.toString()),
        backgroundColor: Color(0xff63E55F),
      ),
      body: Stack(
        children: [
          PDFView(
            filePath: widget.filePath,
            onRender: (_pages) {
              // PDF is rendered, stop loading
              setState(() {
                isLoading = false;
              });
            },
            onError: (error) {
              // Handle any errors that occur while rendering the PDF
            },
            onPageError: (page, error) {
              // Handle any errors that occur while rendering a specific page
            },
            onViewCreated: (PDFViewController pdfViewController) {
              this.pdfViewController = pdfViewController;
            },
          ),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      floatingActionButton: isLoading // Hide FAB while loading
          ? null
          : FloatingActionButton(
              onPressed: _downloadPDF,
              child: Icon(Icons.download),
              backgroundColor: Color(0xff63E55F),
            ),
    );
  }
}
