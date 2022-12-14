import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tren_boong_concept/features/order/total_price.dart';
import '../../../infrastructure/repository/order_repository.dart';
import '../../../utility/save_data.dart';
import '../../entity/order_detail_entity.dart';
import '../../entity/order_entity.dart';
import '../../entity/product_entity.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  //pass value to state to reponse to UI

  OrderBloc({required OrderRepository orderrepository})
      : _orderrepository = orderrepository,
        order = OrderEntity(
            userId: SaveData.userId, orderDetails: [], totalPrice: 0),
        super(OrderInitialState()) {
    on<LoadOrderEvent>((event, emit) async {
      emit(OrderLoadingState());
      try {
        //call repository to get local saved order, if have nothing create new order
        emit(OrderLoadSuccessState(order));
      } catch (e) {
        //do something
        emit(OrderLoadFailState());
      }
    });
    on<AddProductItem>((event, emit) async {
      try {
        addProduct(event.product);
        emit(OrderUpdateSuccess(order));
      } catch (e) {
        //do something
        emit(OrderUpdateFail());
      }
    });

    on<DecreaseProductItem>((event, emit) async {
      try {
        decreaseProduct(event.product);
        emit(OrderUpdateSuccess(order));
      } catch (e) {
        //do something
        print(e.toString());
        emit(OrderUpdateFail());
      }
    });

    on<AddCoupon>((event, emit) async {
      order.coupon = event.coupon;
      order.totalPrice -= event.coupon.couponPrice;
      SaveData.selectedCouponId = event.coupon.id;
      emit(OrderUpdateSuccess(order));
    });

    on<EmitOrder>((event, emit) async {
      //do and emit something
      try {
        await Future.delayed(const Duration(seconds: 2));
        await _orderrepository.createReceipt(order);
        //here wait for paying the bill
      } catch (e) {}
    });

    on<CancelOrder>((event, emit) async {
      //do and emit something
    });
  }

  late OrderEntity order;
  final OrderRepository _orderrepository;

  void addProduct(ProductEntity product) {
    bool checkDuplicate = false;
    order.orderDetails.forEach((element) {
      if (element.product.name == product.name) {
        checkDuplicate = true;
        element.quantity += 1;
      }
    });

    if (checkDuplicate == false) {
      order.orderDetails.add(OrderDetailEntity(
          product: product, quantity: 1, price: product.price));
    }
    order.totalPrice += product.price;
  }

  //new
  void decreaseProduct(ProductEntity product) {
    OrderDetailEntity? removedDetail;
    order.orderDetails.forEach((element) {
      if (element.product.name == product.name) {
        element.quantity -= 1;
        if (element.quantity == 0) {
          removedDetail = element;
        }
      }
    });
    if (removedDetail != null) {
      order.orderDetails.remove(removedDetail);
    }

    order.totalPrice -= product.price;
    print(order.totalPrice);
  }
}
