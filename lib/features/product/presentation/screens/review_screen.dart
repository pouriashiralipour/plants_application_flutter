import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../../core/config/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/persian_number.dart';
import '../../../../core/utils/price_formatter.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_progress_indicator.dart';
import '../../../../core/widgets/gap.dart';
import '../../../../core/widgets/app_alert_dialog.dart';
import '../../../../core/widgets/login_required_sheet.dart';
import '../../../auth/data/repositories/auth_repository.dart';
import '../../../auth/presentation/screens/login_screen.dart';

import '../controllers/review_controller.dart';

import '../../domain/entities/review.dart';
import '../../domain/usecases/get_product_reviews.dart';
import '../../domain/usecases/toggle_review_like.dart';
import '../../domain/usecases/add_product_review.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({
    super.key,
    required this.productId,
    required this.averageRating,
    required this.totalReviews,
  });

  final double averageRating;
  final String productId;
  final int totalReviews;

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  late final ReviewController _reviewController;

  bool _isTogglingLike = false;

  int? _ratingFilter;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _reviewController = ReviewController(
      getProductReviews: context.read<GetProductReviews>(),
      toggleReviewLike: context.read<ToggleReviewLike>(),
      addProductReview: context.read<AddProductReview>(),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _reviewController.load(widget.productId);
    });
  }

  Widget _buildRatingFilterChips(bool isLightMode) {
    final items = <int?>[null, 1, 2, 3, 4, 5];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items.map((value) {
          final selected = _ratingFilter == value;
          final label = value == null ? 'همه' : '${value.toString().farsiNumber}';
          return Padding(
            padding: EdgeInsets.only(
              right: value == items.first ? 0 : SizeConfig.getProportionateScreenWidth(8),
            ),
            child: InkWell(
              onTap: () {
                setState(() {
                  _ratingFilter = value;
                });
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: SizeConfig.getProportionateScreenWidth(73),
                height: SizeConfig.getProportionateScreenHeight(35),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: SizeConfig.getProportionateFontSize(16),
                        fontWeight: FontWeight.w900,
                        color: selected ? AppColors.white : AppColors.primary,
                      ),
                    ),
                    SizedBox(width: SizeConfig.getProportionateScreenWidth(8)),
                    SvgPicture.asset(
                      'assets/images/icons/StarBold.svg',
                      colorFilter: .mode(selected ? Colors.white : AppColors.primary, .srcIn),
                      width: SizeConfig.getProportionateScreenWidth(16),
                      height: SizeConfig.getProportionateScreenWidth(16),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildReviewItem(Review review, bool isLightMode, {required VoidCallback onToggleLike}) {
    final name = review.user.fullName.isEmpty ? 'کاربر' : review.user.fullName;
    final likeText = review.likesCount.toString().priceFormatter.farsiNumber;
    final timeText = _formatRelativeTime(review.createdAt);
    final Color likeColor = review.isLikedByMe
        ? AppColors.primary
        : (isLightMode ? AppColors.grey500 : AppColors.grey300);

    final rawAvatar = review.user.profilePic;
    String? avatarUrl;

    if (rawAvatar != null && rawAvatar.trim().isNotEmpty) {
      if (rawAvatar.startsWith('http')) {
        avatarUrl = rawAvatar;
      } else {
        final cleanedPath = rawAvatar.startsWith('/') ? rawAvatar.substring(1) : rawAvatar;
        avatarUrl = '${UrlInfo.baseUrl}/$cleanedPath';
      }
    }

    final hasAvatar = avatarUrl != null && avatarUrl.isNotEmpty;

    return Container(
      padding: EdgeInsets.all(SizeConfig.getProportionateScreenWidth(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: SizeConfig.getProportionateScreenWidth(20),
                backgroundColor: isLightMode ? AppColors.bgSilver1 : AppColors.dark3,
                backgroundImage: hasAvatar ? NetworkImage(avatarUrl) : null,
                child: !hasAvatar
                    ? Text(
                        name.isNotEmpty ? name[0] : '؟',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: SizeConfig.getProportionateFontSize(16),
                        ),
                      )
                    : null,
              ),
              SizedBox(width: SizeConfig.getProportionateScreenWidth(12)),
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: SizeConfig.getProportionateFontSize(14),
                    fontWeight: FontWeight.w900,
                    color: isLightMode ? AppColors.grey900 : AppColors.white,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.getProportionateScreenWidth(12),
                  vertical: SizeConfig.getProportionateScreenHeight(4),
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary, width: 1.2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      review.rating.toString().farsiNumber,
                      style: TextStyle(
                        fontSize: SizeConfig.getProportionateFontSize(16),
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: SizeConfig.getProportionateScreenWidth(4)),
                    SvgPicture.asset(
                      'assets/images/icons/StarBold.svg',
                      colorFilter: .mode(AppColors.primary, .srcIn),
                      width: SizeConfig.getProportionateScreenWidth(16),
                      height: SizeConfig.getProportionateScreenWidth(16),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (review.comment != null && review.comment!.trim().isNotEmpty) ...[
            Gap(SizeConfig.getProportionateScreenHeight(12)),
            Text(
              review.comment!,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: SizeConfig.getProportionateFontSize(12),
                height: 1.5,
                fontWeight: FontWeight.w700,
                color: isLightMode ? AppColors.grey800 : AppColors.grey200,
              ),
            ),
          ],

          Gap(SizeConfig.getProportionateScreenHeight(12)),
          Row(
            children: [
              GestureDetector(
                onTap: onToggleLike,
                child: Row(
                  children: [
                    Text(
                      likeText,
                      style: TextStyle(
                        fontSize: SizeConfig.getProportionateFontSize(14),
                        fontWeight: FontWeight.w600,
                        color: likeColor,
                      ),
                    ),
                    SizedBox(width: SizeConfig.getProportionateScreenWidth(6)),
                    SvgPicture.asset(
                      'assets/images/icons/HeartBold.svg',
                      colorFilter: .mode(likeColor, .srcIn),
                      width: SizeConfig.getProportionateScreenWidth(18),
                      height: SizeConfig.getProportionateScreenWidth(18),
                    ),
                  ],
                ),
              ),
              SizedBox(width: SizeConfig.getProportionateScreenWidth(16)),
              Text(
                timeText,
                style: TextStyle(
                  fontSize: SizeConfig.getProportionateFontSize(12),
                  color: isLightMode ? AppColors.grey600 : AppColors.grey300,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatRelativeTime(DateTime date) {
    final diff = DateTime.now().difference(date);

    if (diff.inDays >= 365) {
      final years = (diff.inDays / 365).floor();
      return '${years.toString().farsiNumber} سال پیش';
    } else if (diff.inDays >= 30) {
      final months = (diff.inDays / 30).floor();
      return '${months.toString().farsiNumber} ماه پیش';
    } else if (diff.inDays >= 1) {
      return '${diff.inDays.toString().farsiNumber} روز پیش';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours.toString().farsiNumber} ساعت پیش';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes.toString().farsiNumber} دقیقه پیش';
    } else {
      return 'همین الان';
    }
  }

  Future<void> _handleToggleLike(Review review) async {
    if (_isTogglingLike) return;

    setState(() {
      _isTogglingLike = true;
    });

    await _reviewController.toggleLike(productId: widget.productId, reviewId: review.id);

    if (!mounted) return;

    setState(() {
      _isTogglingLike = false;
    });

    if (_reviewController.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_reviewController.error!)));
    }
  }

  bool _isLoggedIn() {
    return context.read<AuthRepository>().isAuthed;
  }

  Future<void> _openAddReviewSheet() async {
    await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        bool isSubmitting = false;
        String? sheetMessage;
        bool sheetIsError = true;
        final TextEditingController commentCtrl = TextEditingController();
        int rating = 5;
        return ChangeNotifierProvider<ReviewController>.value(
          value: _reviewController,
          child: StatefulBuilder(
            builder: (sheetContext, setModalState) {
              final isLightMode = Theme.of(sheetContext).brightness == Brightness.light;
              return Container(
                padding: EdgeInsets.only(
                  left: SizeConfig.getProportionateScreenWidth(20),
                  right: SizeConfig.getProportionateScreenWidth(20),
                  top: SizeConfig.getProportionateScreenHeight(16),
                  bottom:
                      MediaQuery.of(sheetContext).viewInsets.bottom +
                      SizeConfig.getProportionateScreenHeight(16),
                ),
                decoration: BoxDecoration(
                  color: isLightMode ? AppColors.white : AppColors.dark2,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: SizeConfig.getProportionateScreenWidth(40),
                        height: 4,
                        decoration: BoxDecoration(
                          color: isLightMode ? AppColors.grey300 : AppColors.dark3,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                    Gap(SizeConfig.getProportionateScreenHeight(16)),
                    if (sheetMessage != null) ...[
                      Gap(SizeConfig.getProportionateScreenHeight(12)),
                      AppAlertDialog(text: sheetMessage!, isError: sheetIsError),
                    ],
                    Gap(SizeConfig.getProportionateScreenHeight(16)),

                    Text(
                      'ثبت دیدگاه',
                      style: TextStyle(
                        fontSize: SizeConfig.getProportionateFontSize(16),
                        fontWeight: FontWeight.w700,
                        color: isLightMode ? AppColors.grey900 : AppColors.white,
                      ),
                    ),
                    Gap(SizeConfig.getProportionateScreenHeight(12)),
                    Text(
                      'امتیاز شما',
                      style: TextStyle(
                        fontSize: SizeConfig.getProportionateFontSize(14),
                        fontWeight: FontWeight.w600,
                        color: isLightMode ? AppColors.grey800 : AppColors.grey200,
                      ),
                    ),
                    Gap(SizeConfig.getProportionateScreenHeight(8)),
                    Row(
                      children: List.generate(5, (index) {
                        final starIndex = index + 1;
                        final filled = starIndex <= rating;
                        return IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            setModalState(() {
                              rating = starIndex;
                            });
                          },
                          icon: Icon(
                            filled ? Icons.star : Icons.star_border,
                            color: AppColors.primary,
                            size: SizeConfig.getProportionateScreenWidth(24),
                          ),
                        );
                      }),
                    ),
                    Gap(SizeConfig.getProportionateScreenHeight(12)),
                    TextField(
                      controller: commentCtrl,
                      maxLines: 4,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        hintText: 'نظر خود را درباره این محصول بنویسید...',
                        hintStyle: TextStyle(
                          fontSize: SizeConfig.getProportionateFontSize(13),
                          color: isLightMode ? AppColors.grey500 : AppColors.grey400,
                        ),
                        filled: true,
                        fillColor: isLightMode ? AppColors.bgSilver1 : AppColors.dark3,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    Gap(SizeConfig.getProportionateScreenHeight(16)),
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            isShadow: false,
                            width: 50,
                            onTap: () => Navigator.pop(sheetContext, false),
                            text: 'انصراف',
                            color: isLightMode ? AppColors.bgSilver1 : AppColors.dark3,
                            textColor: AppColors.primary,
                            fontSize: SizeConfig.getProportionateFontSize(13),
                          ),
                        ),
                        SizedBox(width: SizeConfig.getProportionateScreenWidth(12)),
                        Expanded(
                          child: isSubmitting
                              ? const AppProgressBarIndicator()
                              : AppButton(
                                  width: 50,
                                  onTap: () async {
                                    if (rating == 0) return;
                                    final comment = commentCtrl.text.trim();
                                    if (comment.isEmpty) {
                                      setModalState(() {
                                        sheetMessage = 'متن دیدگاه الزامی است.';
                                        sheetIsError = true;
                                      });
                                      return;
                                    }

                                    setModalState(() {
                                      isSubmitting = true;
                                    });

                                    await sheetContext.read<ReviewController>().addReview(
                                      productId: widget.productId,
                                      rating: rating,
                                      comment: commentCtrl.text.trim(),
                                    );

                                    setModalState(() {
                                      isSubmitting = false;
                                    });

                                    final controller = sheetContext.read<ReviewController>();
                                    if (controller.error != null) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(SnackBar(content: Text(controller.error!)));
                                      return;
                                    }
                                    Navigator.pop(sheetContext, true);
                                  },

                                  text: 'ثبت دیدگاه',
                                  color: AppColors.primary,
                                  fontSize: SizeConfig.getProportionateFontSize(13),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ReviewController>.value(
      value: _reviewController,
      child: Scaffold(
        body: SafeArea(
          child: Consumer<ReviewController>(
            builder: (context, controller, _) {
              final bool isLightMode = Theme.of(context).brightness == Brightness.light;

              final ratingText = widget.averageRating.toStringAsFixed(1).farsiNumber;
              final reviewsCountText = widget.totalReviews == 0
                  ? ''
                  : '(${widget.totalReviews.toString().priceFormatter.farsiNumber} نظر)';

              final reviews = controller.reviews;
              final filtered = _ratingFilter == null
                  ? reviews
                  : reviews.where((r) => r.rating == _ratingFilter).toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.getProportionateScreenWidth(24),
                      vertical: SizeConfig.getProportionateScreenHeight(16),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.arrow_back,
                            color: isLightMode ? AppColors.grey900 : AppColors.white,
                          ),
                        ),
                        SizedBox(width: SizeConfig.getProportionateScreenWidth(8)),
                        Expanded(
                          child: Text(
                            '$ratingText $reviewsCountText',
                            style: TextStyle(
                              fontSize: SizeConfig.getProportionateFontSize(18),
                              fontWeight: FontWeight.w700,
                              color: isLightMode ? AppColors.grey900 : AppColors.white,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            final ok = _isLoggedIn();
                            if (!ok) {
                              final goLogin = await showLoginRequiredSheet(
                                context: context,
                                title: 'ثبت دیدگاه',
                                message: 'برای ثبت دیدگاه ابتدا وارد حساب کاربری شوید.',
                                icon: Icons.rate_review_rounded,
                                loginText: 'ورود / ثبت‌نام',
                                cancelText: 'باشه',
                              );

                              if (goLogin == true && context.mounted) {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    fullscreenDialog: true,
                                    builder: (_) => const LoginScreen(),
                                  ),
                                );
                              }
                              return;
                            }

                            await _openAddReviewSheet();
                          },

                          icon: SvgPicture.asset(
                            'assets/images/icons/PaperPlus.svg',
                            height: SizeConfig.getProportionateScreenWidth(24),
                            width: SizeConfig.getProportionateScreenWidth(24),
                            colorFilter: .mode(
                              isLightMode ? AppColors.grey900 : AppColors.white,
                              .srcIn,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Gap(SizeConfig.getProportionateScreenHeight(16)),
                  Padding(
                    padding: EdgeInsets.only(right: SizeConfig.getProportionateScreenWidth(24)),
                    child: _buildRatingFilterChips(isLightMode),
                  ),
                  Gap(SizeConfig.getProportionateScreenHeight(16)),

                  Expanded(
                    child: controller.isLoading && controller.reviews.isEmpty
                        ? const Center(child: AppProgressBarIndicator())
                        : controller.error != null && controller.reviews.isEmpty
                        ? Center(
                            child: Text(
                              controller.error!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.error,
                                fontSize: SizeConfig.getProportionateFontSize(13),
                              ),
                            ),
                          )
                        : filtered.isEmpty
                        ? Center(
                            child: Text(
                              'برای این فیلتر، دیدگاهی پیدا نشد.',
                              style: TextStyle(
                                fontSize: SizeConfig.getProportionateFontSize(14),
                                color: isLightMode ? AppColors.grey600 : AppColors.grey300,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.getProportionateScreenWidth(12),
                            ),
                            child: ListView.separated(
                              itemBuilder: (context, index) {
                                final review = filtered[index];
                                return _buildReviewItem(
                                  review,
                                  isLightMode,
                                  onToggleLike: () => _handleToggleLike(review),
                                );
                              },
                              separatorBuilder: (_, __) =>
                                  Gap(SizeConfig.getProportionateScreenHeight(16)),
                              itemCount: filtered.length,
                            ),
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
