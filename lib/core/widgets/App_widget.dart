import 'package:flightbooking/core/constants/app_colors.dart';
import 'package:flightbooking/core/utils/formater.dart';
import 'package:flightbooking/features/flight_details/data/models/flight_detail_model.dart';
import 'package:flightbooking/features/flight_details/presentation/pages/flight_detail_screen.dart';
import 'package:flightbooking/features/flight_details/presentation/provider/flight_detail_provider.dart';
import 'package:flightbooking/features/flight_search/data/models/flight_search_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AppWidget {
  static Widget appText({
    required String text,
    double fontSize = 12,
    FontWeight fontWeight = FontWeight.w400,
    Color color = AppColors.textDark,
    TextAlign textAlign = TextAlign.start,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color:  color,
      ),
    );
  }


  SizedBox appSizeBoxWidth([double width = 5]) {
    return SizedBox(width: width);
  }

  SizedBox appSizeBoxHeight([double height = 5]) {
    return SizedBox(height: height);
  }
}

// border............
enum DottedBorderType {
  rounded,
  topArc,
  straight,
}
class AppDottedBorder extends StatelessWidget {
  final Widget child;

  // BORDER
  final Color borderColor;
  final double strokeWidth;
  final List<double> dashPattern;

  // GRADIENT
  final List<Color>? gradientColors;

  // RADIUS
  final double borderRadius;

  // PADDING
  final EdgeInsets padding;

  // TYPE
  final DottedBorderType borderType;

  const AppDottedBorder({
    super.key,
    required this.child,

    // BORDER
    this.borderColor = Colors.blue,
    this.strokeWidth = 2,
    this.dashPattern = const [8, 4],

    // GRADIENT
    this.gradientColors,

    // RADIUS
    this.borderRadius = 20,

    // PADDING
    this.padding = const EdgeInsets.all(8),

    // TYPE
    this.borderType = DottedBorderType.rounded,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DottedBorderPainter(
        borderColor: borderColor,
        strokeWidth: strokeWidth,
        dashPattern: dashPattern,
        gradientColors: gradientColors,
        borderRadius: borderRadius,
        borderType: borderType,
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
class _DottedBorderPainter extends CustomPainter {
  final Color borderColor;
  final double strokeWidth;
  final List<double> dashPattern;
  final List<Color>? gradientColors;
  final double borderRadius;
  final DottedBorderType borderType;

  _DottedBorderPainter({
    required this.borderColor,
    required this.strokeWidth,
    required this.dashPattern,
    required this.gradientColors,
    required this.borderRadius,
    required this.borderType,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    // GRADIENT
    if (gradientColors != null) {
      paint.shader = LinearGradient(
        colors: gradientColors!,
      ).createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );
    } else {
      paint.color = borderColor;
    }

    final path = Path();

    switch (borderType) {

    // FULL ROUNDED BORDER
      case DottedBorderType.rounded:

        path.addRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(0, 0, size.width, size.height),
            Radius.circular(borderRadius),
          ),
        );

        break;

    // TOP ARC BORDER
      case DottedBorderType.topArc:

        final rect = Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.width / 2,
        );

        path.addArc(
          rect,
          3.3,
          3.1,
        );

        break;

    // STRAIGHT BORDER
      case DottedBorderType.straight:

        path.moveTo(0, size.height / 2);

        path.lineTo(
          size.width,
          size.height / 2,
        );

        break;
    }

    final dashWidth = dashPattern[0];
    final dashSpace = dashPattern[1];

    for (final metric in path.computeMetrics()) {
      double distance = 0;

      while (distance < metric.length) {
        final extractPath = metric.extractPath(
          distance,
          distance + dashWidth,
        );

        canvas.drawPath(extractPath, paint);

        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double height;
  final double? width;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final double fontSize;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry padding;
  final Widget? child;

  const AppButton({
    super.key,
    required this.text,
    required this.onTap,
    this.height = 45,
    this.width,
    this.backgroundColor = AppColors.black,
    this.textColor = AppColors.white,
    this.borderRadius = 30,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w600,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: onTap,
        child: Container(
          height: height,
          width: width,
          padding: padding,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: child ??
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                ),
              ),
        ),
      ),
    );
  }
}

// use form image ...........
class AppCircleImage extends StatelessWidget {
  final String imagePath;
  final double radius;
  final BoxFit fit;
  final Color? backgroundColor;
  final Widget? errorWidget;

  const AppCircleImage({
    super.key,
    required this.imagePath,
    this.radius = 30,
    this.fit = BoxFit.contain,
    this.backgroundColor,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? Colors.grey.shade200,
      child: ClipOval(
        child: AppImage(
          imagePath: imagePath,
          height: radius * 2,
          width: radius * 2,
          fit: fit,
          errorWidget: errorWidget,
        ),
      ),
    );
  }
}
class AppImage extends StatelessWidget {
  final String imagePath;
  final double? height;
  final double? width;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? errorWidget;

  const AppImage({
    super.key,
    required this.imagePath,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.errorWidget,
  });

  bool get isSvg => imagePath.toLowerCase().endsWith('.svg');

  bool get isNetwork =>
      imagePath.startsWith('http') ||
          imagePath.startsWith('https');

  @override
  Widget build(BuildContext context) {
    Widget image;

    if (isSvg) {
      image = isNetwork
          ? SvgPicture.network(
        imagePath,
        fit: fit,
        placeholderBuilder: (_) => _loadingWidget(),
      )
          : SvgPicture.asset(
        imagePath,
        fit: fit,
      );
    } else {
      image = isNetwork
          ? Image.network(
        imagePath,
        height: height,
        width: width,
        fit: fit,
        errorBuilder: (_, __, ___) => _errorView(),
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return _loadingWidget();
        },
      )
          : Image.asset(
        imagePath,
        height: height,
        width: width,
        fit: fit,
        errorBuilder: (_, __, ___) => _errorView(),
      );
    }

    if (borderRadius != null) {
      image = ClipRRect(
        borderRadius: borderRadius!,
        child: image,
      );
    }

    return image;
  }

  Widget _loadingWidget() {
    return const Center(
      child: CircularProgressIndicator(strokeWidth: 2),
    );
  }

  Widget _errorView() {
    return errorWidget ??
        const Icon(
          Icons.broken_image_outlined,
          color: Colors.grey,
        );
  }
}
// app text field..............
class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final TextInputType keyboardType;
  final bool obscureText;
  final IconData? suffixIcon;
  final Color suffixIconColor;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final bool isBorderHide;

  const AppTextField({
    super.key,
    this.controller,
    this.labelText = "Enter text",
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.suffixIcon,
    this.suffixIconColor = Colors.grey,
    this.onTap,
    this.onChanged,
    this.readOnly = false,
    this.isBorderHide = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,
      cursorColor: AppColors.shadow,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black,
        fontWeight: FontWeight.w600 ,
      ),
      decoration: InputDecoration(
        labelText: labelText,

        labelStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),

        floatingLabelStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),

        // ENABLE BORDER
        enabledBorder: isBorderHide
            ? InputBorder.none
            : const UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.shadow,
                width: 1,
              ),
        ),

        // FOCUSED BORDER
        focusedBorder: isBorderHide
            ? InputBorder.none
            : const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.shadow,
            width: 2,
          ),
        ),

        suffixIcon: suffixIcon != null
            ? Icon(
          suffixIcon,
          color: suffixIconColor,
          size: 20,
        )
            : null,
      ),
    );
  }
}
// app card .........
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double elevation;
  final double marginHorizontally;
  final double marginVertically;
  final Color backgroundColor;

  // BORDER
  final bool showBorder;
  final Color borderColor;
  final double borderWidth;

  // ADD THIS
  final Clip clipBehavior;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 26,
    this.elevation = 0,
    this.marginHorizontally = 5,
    this.marginVertically = 5,
    this.backgroundColor = AppColors.chipBg,

    // BORDER
    this.showBorder = false,
    this.borderColor = AppColors.shadow,
    this.borderWidth = 2.5,

    // ADD THIS
    this.clipBehavior = Clip.antiAlias,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      color: backgroundColor,

      // CHANGE THIS
      clipBehavior: clipBehavior,

      surfaceTintColor: Colors.transparent,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),

        side: showBorder
            ? BorderSide(
          color: borderColor,
          width: borderWidth,
        )
            : BorderSide.none,
      ),

      margin: EdgeInsets.symmetric(
        horizontal: marginHorizontally,
        vertical: marginVertically,
      ),

      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}

class AppRichText extends StatelessWidget {
  final String title;
  final String subtitle;

  const AppRichText({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "$title ",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          TextSpan(
            text: "($subtitle)",
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class AppFromToCartTime extends StatelessWidget {
  final AirportModel departure;
  final AirportModel arrival;
  final String duration;
  const AppFromToCartTime({super.key, required this.departure, required this.arrival, required this.duration});

  @override
  Widget build(BuildContext context) {
    final d = departure;
    final a = arrival;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppWidget.appText(text: AppFormatter.formatTime(d.time),color: AppColors.primaryBlue,fontWeight: FontWeight.bold,fontSize: 10),
            AppDottedBorder(
              strokeWidth: 1.5,
              dashPattern: [3, 1],
              borderType: DottedBorderType.topArc,
              gradientColors: [
                AppColors.shadow,
                AppColors.primaryBlue,
                AppColors.shadow,
              ],
              child: Center(
                child: Icon(
                    Icons.flight_takeoff,
                    color: AppColors.primaryBlue,
                    size: 20
                ),
              ),
            ),
            AppWidget.appText(text: AppFormatter.formatTime(a.time),color: AppColors.primaryBlue,fontWeight: FontWeight.bold,fontSize: 10),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppRichText(title: d.airportCode, subtitle: d.city),
            AppWidget.appText(text: duration,fontSize: 10),
            AppRichText(title: a.airportCode, subtitle: a.city),
          ],
        ),
      ],
    );
  }
}

// ticket card ...
class TicketCard extends StatelessWidget {
  final Widget topChild;
  final Widget bottomChild;
  final Clip clipBehavior;

  const TicketCard({
    super.key,
    required this.topChild,
    required this.bottomChild,
    this.clipBehavior = Clip.antiAlias,
  });

  @override
  Widget build(BuildContext context) {

    const double cutSize = 24;

    return AppCard(
      padding: EdgeInsets.zero,
      clipBehavior: clipBehavior,

      child: Column(
        children: [

          // TOP
          Padding(
            padding: const EdgeInsets.all(16),
            child: topChild,
          ),

          // CENTER CUT SECTION
          SizedBox(
            height: cutSize,
            child: Stack(
              alignment: Alignment.center,
              children: [

                // divider line
                Positioned(
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: AppStatBorderCard(),
                  ),
                ),

                // left cut
                Positioned(
                  left: -(cutSize / 2),
                  child: Container(
                    height: cutSize,
                    width: cutSize,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.scaffoldBg,
                    ),
                  ),
                ),

                // right cut
                Positioned(
                  right: -(cutSize / 2),
                  child: Container(
                    height: cutSize,
                    width: cutSize,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.scaffoldBg,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // BOTTOM
          Padding(
            padding: const EdgeInsets.all(16),
            child: bottomChild,
          ),
        ],
      ),
    );
  }
}

class AppCardDate extends StatelessWidget {
  final String title;
  final String value;
  const AppCardDate({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppWidget.appText(text: title,color: AppColors.textLight),
        AppWidget.appText(text: value,fontWeight: FontWeight.bold),
      ],
    );
  }
}

class AppCardLogoTitleId extends StatelessWidget {
  final String logo;
  final String title;
  final String flightNumber;
  final bool isFlightNumShow;
  const AppCardLogoTitleId({super.key, required this.logo, required this.title, required this.flightNumber, this.isFlightNumShow = false});

  @override
  Widget build(BuildContext context) {
    return   Row(
      children: [
        AppCircleImage(imagePath: logo,radius: 20,),
        AppWidget().appSizeBoxWidth(20),
        AppWidget.appText(text: title,fontSize: 15,fontWeight: FontWeight.w600),
        Spacer(),
        if(isFlightNumShow)
          AppWidget.appText(text: flightNumber,fontSize: 14,fontWeight: FontWeight.w600,color: Colors.grey),
      ],
    );
  }
}

class AppStatBorderCard extends StatelessWidget {
  const AppStatBorderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: AppDottedBorder(
        borderType: DottedBorderType.straight,
        borderColor: AppColors.shadow,
        borderRadius: 0,
        strokeWidth: 1.5,
        dashPattern: [4,3],
        child: const SizedBox(
          width: double.infinity,
          height: 20,
        ),
      ),
    );
  }
}

class AppSearchScreenCart extends StatelessWidget {
  const AppSearchScreenCart({super.key});

  @override
  Widget build(BuildContext context) {
    return TicketCard(
      topChild: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child:AppImage(imagePath: "https://upload.wikimedia.org/wikipedia/commons/1/17/Google-flutter-logo.png",height: 35,width: 80,fit: BoxFit.contain,),
          ),
          AppWidget().appSizeBoxHeight(15),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppWidget.appText(text: "07:47",color: AppColors.primaryBlue,fontWeight: FontWeight.bold,fontSize: 10),
              AppDottedBorder(
                strokeWidth: 1.5,
                dashPattern: [3, 1],
                borderType: DottedBorderType.topArc,
                gradientColors: [
                  AppColors.shadow,
                  AppColors.primaryBlue,
                  AppColors.shadow,
                ],
                child: Center(
                  child: Icon(
                      Icons.flight_takeoff,
                      color: AppColors.primaryBlue,
                      size: 20
                  ),
                ),
              ),
              AppWidget.appText(text: "14:47",color: AppColors.primaryBlue,fontWeight: FontWeight.bold,fontSize: 10),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppRichText(title: "CGK", subtitle: "NRT"),
              AppWidget.appText(text: "7h 20m",fontSize: 10),
              AppRichText(title: "Jakarta", subtitle: "Tokyo"),
            ],
          ),
        ],
      ),
      bottomChild: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppCardDate(title: 'Date', value: 'Jan 20,2025',),
              AppCardDate(title: 'Date', value: 'Jan 20,2025',),
            ],
          )
        ],
      ),
    );
  }
}

class AppSearchResultScreenCart extends StatelessWidget {
  final FlightModel flightModel;
  const AppSearchResultScreenCart({super.key, required this.flightModel});

  @override
  Widget build(BuildContext context) {
    final f = flightModel;
    return TicketCard(
        topChild: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppCardLogoTitleId(logo: f.airlineLogo, title: f.airlineName, flightNumber: f.flightNumber,),
            AppWidget().appSizeBoxHeight(15),
            AppFromToCartTime(departure: f.departure, arrival: f.arrival, duration: f.duration),
          ],
        ),
        bottomChild: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppWidget.appText(text: "\$${f.price.amount}",fontSize: 14,color: AppColors.primaryBlue,fontWeight: FontWeight.bold),
                    AppWidget.appText(text: "/person",color: Colors.grey,)
                  ],
                ),
                AppButton(text: "Select flight", onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChangeNotifierProvider(
                        create: (_) => FlightDetailProvider()..getFlightDetail(f.id),
                        child: const FlightDetailScreen(),
                      ),
                    ),
                  );
                },fontSize: 12,height: 36,)
              ],
            ),
          ],
        )
    );
  }
}

class AppCircleIconButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;

  const AppCircleIconButton({
    super.key,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(
            icon,
            color: Colors.grey,
            size: 20,
          ),
        ),
      ),
    );
  }
}



