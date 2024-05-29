// import 'package:intl/intl.dart';
// import 'package:quotation_app/get_price.dart';

// class QuotationCalculator {
//   static Map<String, dynamic> calculateQuotationDetails(
//       Map<String, dynamic> quotationData, List<Price> prices) {
//     String? cardSizeString = quotationData['Size of Card'] as String?;
//     Price? selectedCardSize = prices.firstWhere(
//       (price) => price.name == cardSizeString,
//       orElse: () => Price(name: '', label: '', price: 0.0),
//     );

//     String? sizeOfPaper = quotationData['Size of Paper']?.toString();
//     int numberOfPages = quotationData['Number of Pages'] ?? 0;

//     int numberOfSheets = _calculateNumberOfSheets(sizeOfPaper, numberOfPages);

//     double pricePerSheet = selectedCardSize.price / 95;
//     double totalCardPrice = pricePerSheet * numberOfSheets;

//     String? printingColorText = quotationData['Color(s) of Text']?.toString();
//     String? printingColorCover = quotationData['Color(s) of Cover']?.toString();

//     Price? selectedPrintingColorText = prices.firstWhere(
//       (price) => price.name == printingColorText,
//       orElse: () => Price(name: '', label: '', price: 0.0),
//     );

//     Price? selectedPrintingColorCover = prices.firstWhere(
//       (price) => price.name == printingColorCover,
//       orElse: () => Price(name: '', label: '', price: 0.0),
//     );

//     double pricePerSheetOfPrintingColorText = selectedPrintingColorText.price;
//     double pricePerSheetOfPrintingColorCover = selectedPrintingColorCover.price;

//     String finishingCosts = quotationData['Finishing'] ?? '';
//     List<String> selectedFinishingOptions = finishingCosts.split(', ');

//     double totalFinishingCost = selectedFinishingOptions.fold<double>(
//           0,
//           (previousValue, option) =>
//               previousValue +
//               prices.firstWhere((price) => price.name == option.trim()).price,
//         ) ??
//         0.0;

//     int? paperGrammage = quotationData['Grammage of Paper'] as int?;
//     double paperGrammagePrice = prices
//         .firstWhere((price) => price.name == paperGrammage.toString(),
//             orElse: () => Price(name: '', label: '', price: 0.0))
//         .price;

//     int? coverGrammage = quotationData['Grammage of Card'] as int?;
//     double coverGrammagePrice = prices
//         .firstWhere((price) => price.name == coverGrammage.toString(),
//             orElse: () => Price(name: '', label: '', price: 0.0))
//         .price;

//     double plateMakingCost =
//         (quotationData['Plate Making Cost (₦)'] ?? 0).toDouble();
//     double runningCost =
//         (quotationData['Running Cost (Offset) (₦)'] ?? 0).toDouble();
//     double designerCost =
//         (quotationData['Graphics Design Cost (₦)'] ?? 0).toDouble();

//     int numberOfCopies = quotationData['Number of Copies'] ?? 0;

//     double costOfPrintingAll = totalCardPrice +
//         pricePerSheetOfPrintingColorText +
//         pricePerSheetOfPrintingColorCover +
//         totalFinishingCost +
//         paperGrammagePrice +
//         coverGrammagePrice;

//     double plateMakingCostPerUnit = plateMakingCost / numberOfCopies;
//     double designerCostPerUnit = designerCost / numberOfCopies;
//     double runningCostPerUnit = runningCost / numberOfCopies;

//     double totalOtherCostPerUnit =
//         plateMakingCostPerUnit + designerCostPerUnit + runningCostPerUnit;
//     double costOfPrintingPerUnit = costOfPrintingAll + totalOtherCostPerUnit;

//     double grandPrice = costOfPrintingPerUnit * numberOfCopies;

//     String formattedCostOfPrintingAll = NumberFormat.currency(
//       symbol: '₦',
//       decimalDigits: 2,
//     ).format(costOfPrintingPerUnit ?? 0.0);

//     String formattedGrandPrice = NumberFormat.currency(
//       symbol: '₦',
//       decimalDigits: 2,
//     ).format(grandPrice ?? 0.0);

//     return {
//       'pricePerSheet': pricePerSheet,
//       // 'totalCardPrice': totalCardPrice,
//       'priceOfSheetOfPaper': totalCardPrice.ceil().toDouble(),
//       'pricePerSheetOfPrintingColorText': pricePerSheetOfPrintingColorText,
//       'pricePerSheetOfPrintingColorCover': pricePerSheetOfPrintingColorCover,
//       'totalFinishingCost': totalFinishingCost,
//       'paperGrammagePrice': paperGrammagePrice,
//       'coverGrammagePrice': coverGrammagePrice,
//       'plateMakingCost': plateMakingCostPerUnit.ceil().toDouble(),
//       'runningCost': runningCostPerUnit.ceil().toDouble(),
//       'designerCost': designerCostPerUnit.ceil().toDouble(),
//       'totalPricePerUnit': formattedCostOfPrintingAll,
//       'grandPrice': grandPrice,
//       'formattedGrandPrice': formattedGrandPrice,
//     };
//   }

//   static int _calculateNumberOfSheets(String? sizeOfPaper, int numberOfPages) {
//     int divisor = 0;

//     if (sizeOfPaper == "9 x 6") {
//       divisor = 16;
//     } else if (sizeOfPaper == "8.5 x 11") {
//       divisor = 8;
//     } else if (sizeOfPaper == "4 x 6") {
//       divisor = 24;
//     } else if (sizeOfPaper == "8.27 x 10.5") {
//       divisor = 8;
//     } else if (sizeOfPaper == "5.83 x 8.27") {
//       divisor = 16;
//     } else if (sizeOfPaper == "4.13 x 5.83") {
//       divisor = 24;
//     } else if (sizeOfPaper == "2.91 x 4.13") {
//       divisor = 32;
//     } else if (sizeOfPaper == "2.05 x 2.91") {
//       divisor = 48;
//     }
//     return (numberOfPages / divisor).ceil();
//   }
// }

import 'package:intl/intl.dart';
import 'package:quotation_app/get_price.dart';

class QuotationCalculator {
  static Map<String, dynamic> calculateQuotationDetails(
      Map<String, dynamic> quotationData, List<Price> prices) {
    // Fetching the price for paper grammage
    int? paperGrammage = quotationData['Grammage of Paper'] as int?;
    double paperGrammagePrice = prices
        .firstWhere((price) => price.name == paperGrammage.toString(),
            orElse: () => Price(name: '', label: '', price: 0.0))
        .price;

    // Fetching the price for cover grammage
    int? coverGrammage = quotationData['Grammage of Card'] as int?;
    double coverGrammagePrice = prices
        .firstWhere((price) => price.name == coverGrammage.toString(),
            orElse: () => Price(name: '', label: '', price: 0.0))
        .price;

    // Size of paper and number of pages
    String? sizeOfPaper = quotationData['Size of Paper']?.toString();
    int numberOfPages = quotationData['Number of Pages'] ?? 0;

    int numberOfPagesForPaper = numberOfPages - 4;

    // Calculate the number of sheets based on paper size and number of pages
    double numberOfSheets =
        _calculateNumberOfSheets(sizeOfPaper, numberOfPagesForPaper);

    int numberOfCopies = quotationData['Number of Copies'] ?? 0;

    // Calculate the price per sheet for paper and cover grammage
    double priceOfPaperGrammage = paperGrammagePrice / 500;
    double pricePerSheetOfPaperGrammage = priceOfPaperGrammage * numberOfSheets;

    double priceOfCoverGrammage = coverGrammagePrice / 100;
    int noOfCoverUsed = 4 * numberOfCopies;
    int numberOfSheetsForCover = _calculateNumberOfSheetsOfCover(sizeOfPaper);
    double priceSheetOfCoverGrammage = noOfCoverUsed / numberOfSheetsForCover;
    double pricePerSheetOfCoverGrammage =
        (priceSheetOfCoverGrammage * priceOfCoverGrammage) / numberOfCopies;

    // Fetching the price for printing colors (text and cover)
    String? printingColorText = quotationData['Color(s) of Text']?.toString();
    String? printingColorCover = quotationData['Color(s) of Cover']?.toString();

    Price? selectedPrintingColorText = prices.firstWhere(
      (price) => price.name == printingColorText,
      orElse: () => Price(name: '', label: '', price: 0.0),
    );

    Price? selectedPrintingColorCover = prices.firstWhere(
      (price) => price.name == printingColorCover,
      orElse: () => Price(name: '', label: '', price: 0.0),
    );

    double pricePerSheetOfPrintingColorText =
        selectedPrintingColorText.price / numberOfCopies;
    double pricePerSheetOfPrintingColorCover =
        selectedPrintingColorCover.price / numberOfCopies;

    // Calculate the total finishing cost
    String finishingCosts = quotationData['Finishing'] ?? '';
    List<String> selectedFinishingOptions = finishingCosts.split(', ');

    double totalFinishingCost = selectedFinishingOptions.fold<double>(
          0,
          (previousValue, option) =>
              previousValue +
              prices.firstWhere((price) => price.name == option.trim()).price,
        ) ??
        0.0;

    double totalFinishingPerUnit = totalFinishingCost / numberOfCopies;

    // Fetching other costs from quotation data
    double plateMakingCost =
        (quotationData['Plate Making Cost (₦)'] ?? 0).toDouble();
    double runningCost =
        (quotationData['Running Cost (Offset) (₦)'] ?? 0).toDouble() ?? 0;
    double designerCost =
        (quotationData['Graphics Design Cost (₦)'] ?? 0).toDouble();
    double editingCost =
        (quotationData['Editing Cost (₦)'] ?? 0).toDouble() ?? 0;
    double impressionCost =
        (quotationData['Impression Cost (₦)'] ?? 0).toDouble();

    // Calculate the total cost for all elements
    double costOfPrintingAll = pricePerSheetOfPaperGrammage +
        pricePerSheetOfCoverGrammage +
        pricePerSheetOfPrintingColorText +
        pricePerSheetOfPrintingColorCover +
        totalFinishingPerUnit;

    // Calculate per unit costs for plate making, running, and designer
    double plateMakingCostPerUnit = plateMakingCost / numberOfCopies;
    double designerCostPerUnit = designerCost / numberOfCopies;
    double runningCostPerUnit = runningCost / numberOfCopies;
    double editingCostPerUnit = editingCost / numberOfCopies;
    double impressionCostPerUnit = impressionCost / numberOfCopies;

    // Calculate total other costs per unit
    double totalOtherCostPerUnit = plateMakingCostPerUnit +
        designerCostPerUnit +
        runningCostPerUnit +
        editingCostPerUnit +
        impressionCostPerUnit;
    double costOfPrintingPerUnit = costOfPrintingAll + totalOtherCostPerUnit;

    // Calculate grand price for all copies
    double grandPrice = costOfPrintingPerUnit * numberOfCopies;

    // Format prices to currency
    String formattedCostOfPrintingAll = NumberFormat.currency(
      symbol: '₦ ',
      decimalDigits: 2,
    ).format(costOfPrintingPerUnit ?? 0.0);

    String formattedGrandPrice = NumberFormat.currency(
      symbol: '₦ ',
      decimalDigits: 2,
    ).format(grandPrice ?? 0.0);

    return {
      'pricePerSheetOfPaperGrammage': pricePerSheetOfPaperGrammage.toDouble(),
      'priceOfSheetOfCoverGrammage': pricePerSheetOfCoverGrammage.toDouble(),
      'pricePerSheetOfPrintingColorText': pricePerSheetOfPrintingColorText,
      'pricePerSheetOfPrintingColorCover': pricePerSheetOfPrintingColorCover,
      'totalFinishingCost': totalFinishingPerUnit,
      'plateMakingCost': plateMakingCostPerUnit.toDouble(),
      'runningCost': runningCostPerUnit.toDouble(),
      'designerCost': designerCostPerUnit.toDouble(),
      'editingCost': editingCostPerUnit.toDouble(),
      'impressionCost': impressionCostPerUnit.toDouble(),
      'totalPricePerUnit': formattedCostOfPrintingAll,
      'grandPrice': grandPrice,
      'formattedGrandPrice': formattedGrandPrice,
    };
  }

  // Function to calculate the number of sheets based on paper size and number of pages

  static double _calculateNumberOfSheets(
      String? sizeOfPaper, int numberOfPages) {
    int divisor = 0;

    if (sizeOfPaper == "9 x 6") {
      divisor = 16;
    } else if (sizeOfPaper == "8.5 x 11") {
      divisor = 8;
    } else if (sizeOfPaper == "4 x 6") {
      divisor = 24;
    } else if (sizeOfPaper == "8.27 x 10.5") {
      divisor = 8;
    } else if (sizeOfPaper == "5.83 x 8.27") {
      divisor = 16;
    } else if (sizeOfPaper == "4.13 x 5.83") {
      divisor = 24;
    } else if (sizeOfPaper == "2.91 x 4.13") {
      divisor = 32;
    } else if (sizeOfPaper == "2.05 x 2.91") {
      divisor = 48;
    }
    return (numberOfPages / divisor);
  }

  static int _calculateNumberOfSheetsOfCover(String? sizeOfPaper) {
    int divisor = 0;

    if (sizeOfPaper == "9 x 6") {
      divisor = 16;
    } else if (sizeOfPaper == "8.5 x 11") {
      divisor = 8;
    } else if (sizeOfPaper == "4 x 6") {
      divisor = 24;
    } else if (sizeOfPaper == "8.27 x 10.5") {
      divisor = 8;
    } else if (sizeOfPaper == "5.83 x 8.27") {
      divisor = 16;
    } else if (sizeOfPaper == "4.13 x 5.83") {
      divisor = 24;
    } else if (sizeOfPaper == "2.91 x 4.13") {
      divisor = 32;
    } else if (sizeOfPaper == "2.05 x 2.91") {
      divisor = 48;
    }
    return divisor;
  }
}
